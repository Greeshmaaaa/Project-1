load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

airt = addfiles("/g/data/up6/gs5098/cdo/air_temp/air-temp-2hr-n-2001.nc","r")
geop = addfiles("/g/data/up6/gs5098/cdo/geopotential_hgt/geopt-ht-2hr-n-2001.nc","r")
relh = addfiles("/g/data/up6/gs5098/cdo/rel_hum/rel-hum-2hr-n-2001.nc","r")
terr = addfiles("/g/data/up6/gs5098/cdo/terrain/terrain.nc","r")
mslp = addfiles("/g/data/up6/gs5098/cdo/av_mslp/av-mslp-2hr-n-2001.nc","r")
sprs = addfiles("/g/data/up6/gs5098/cdo/sfc_pres/sfc-pres-2hr-n-2001.nc","r")

time      = airt[:]->time
pressure  = airt[:]->pressure  ;top to bottom 10,20...1000
lat       = airt[:]->latitude  ;from south to north 
lon       = airt[:]->longitude  ; from west to east
temp      = airt[:]->air_temp   ; Kelvin 
    
z         = geop[:]->geop_ht  ; meter
rh        = relh[:]->relhum ; % 

slp       = mslp[:]->av_mslp  ;
ps        = sprs[:]->sfc_pres  ; pa
zsfs      = terr[:]->topog
printVarSummary(ps)
printVarSummary(zsfs)
printVarSummary(z)
printVarSummary(rh)
printVarSummary(slp)
printVarSummary(pressure)
printVarSummary(temp)

; convert from bottom to top
       pressure = pressure(::-1)
       temp = temp(:,::-1,:,:)
       z    = z(:,::-1,:,:)
       rh   = rh(:,::-1,:,:)
       pressure_3D = conform_dims(dimsizes(temp),pressure, 1)
       printVarSummary(pressure_3D)
       zsfs_3D = conform_dims(dimsizes(ps),zsfs, (/1,2/))
       printVarSummary(zsfs_3D)

        ; convert rh to vapor mixing ratio
       
       q = mixhum_ptrh(pressure_3D, temp, rh, 1) ; pressure_3d is in hpa



; -----------------------------------------------------------
; Calculate CAPE
; -----------------------------------------------------------
       cape3d = wrf_cape_3d(pressure_3D*100, temp, q, z, zsfs_3D, ps, False) ; p in pa
       cape2d = wrf_cape_2d(pressure_3D*100, temp, q, z, zsfs_3D, ps, False) ; p in pa
       printVarSummary(cape3d)
       printVarSummary(cape2d)

       cape3d_max = dim_max_n(cape3d, 2)
       printVarSummary(cape3d_max)
	; add missing values
	cape3d@_FillValue = default_fillvalue("float")
	
	;cape3d_max!0 = "time"
	;cape3d&time  =  time
	;cape3d_max!1 = "lat"
        ;cape3d&lat   =  lat
	;cape3d_max!2 = "lon"
        ;cape3d&lon   =  lon

; -----------------------------------------------------------
; write out
; -----------------------------------------------------------
	setfileoption("nc","format","LargeFile")	; to allow writing files > 2 GB
        out_path="/g/data/up6/gs5098/cdo/CAPE/"
        outfile ="cape_3d_2hr-n-2001.nc"
	system("rm -f "+outfile)
	outf = addfile(out_path + outfile,"c")

	; set global attributes
	outf@description = "MLCAPE calculated with wrf_cape_3d (lowest output)"
	outf@calculated_by = "NSW Department of Planning and Environment"
	outf@email = "fei.ji@environment.nsw.gov.au"
	outf@date_calculated = systemfunc("date")

	outf->Times = time
;	outf->XLONG = lon
;	outf->XLAT =  lat
	outf->MLCAPE = cape3d(0,:,0,:,:)
	
	outf->CAPE = cape3d(0,:,:,:,:)
;	outf->CIN = cape3d(1,:,:,:,:)
        delete(outf)

; -----------------------------------------------------------
	setfileoption("nc","format","LargeFile")	; to allow writing files > 2 GB
        out_path="/g/data/up6/gs5098/cdo/CAPE/"
        outfile1 ="cape_2d_2hr-n-2001.nc"
	system("rm -f "+outfile1)
	outf = addfile(out_path + outfile1,"c")

	; set global attributes
	outf@description = "CAPE calculated with wrf_cape_2d"
	outf@calculated_by = "NSW Department of Planning and Environment"
	outf@email = "fei.ji@environment.nsw.gov.au"
	outf@date_calculated = systemfunc("date")

	outf->Times = time
;	outf->XLONG = lon
;	outf->XLAT =  lat
	outf->CAPE = cape2d(0,:,:,:)
	outf->CIN = cape2d(1,:,:,:)
	outf->LCL = cape2d(2,:,:,:)
	outf->LFC = cape2d(3,:,:,:)
	outf->cape3d_max = cape3d_max(0,:,:,:)