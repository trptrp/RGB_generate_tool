pro gen_batch_process
  folderpath = 'D:\tmp\'
  cd, folderpath
  datafiles = FILE_SEARCH('*.cube', COUNT=n)
  for i=0, n do begin
    gen_rgb_img, folderpath + datafiles[i]
  endfor
end