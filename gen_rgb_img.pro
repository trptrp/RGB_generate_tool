pro gen_rgb_img, datafn
  envi_open_file, datafn, /NO_INTERACTIVE_QUERY, /NO_REALIZE, r_fid = fid
  envi_file_query, fid, DIMS = dims, NB = nb, NL = nl, NS = ns, DATA_TYPE = data_type, $
      INTERLEAVE = interleave
  imgdata = []
  for i=0, nb-1 do begin
    data = envi_get_data(DIMS = dims, FID = fid, pos = i)
    imgdata = [[[imgdata]], [[data]]]
  endfor
  
  r = imgdata[*,*,58]
  g = imgdata[*,*,31]
  b = imgdata[*,*,20] 

  imgrgb = [[[r]],[[g]],[[b]]]
  
  WINDOW, 1, XSIZE=NS, YSIZE=NL
  tvscl, imgrgb, TRUE=3
  imgname = strmid(datafn, 0,  STRLEN(datafn)-5) + '.png'
  print, imgname
  saveimage, imgname
end
