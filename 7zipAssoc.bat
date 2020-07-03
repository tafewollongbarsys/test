@echo off

cls

for %%i in (001,7z,arj,bz2,bzip2,cab,cpio,deb,dmg,fat,gz,gzip,hfs,iso,lha,lzh,lzma,ntfs,rar,rpm,squashfs,swm,tar,taz,tbz,tbz2,tgz,tpz,txz,vhd,wim,xar,xz,z,zip) do (
    :: Associations
		assoc .%%i=7-Zip.%%i
		:: Open With
		ftype 7-Zip.%%i="C:\Program Files\7-Zip\7zFM.exe" "%%1"
	)

exit
