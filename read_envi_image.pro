FUNCTION READ_ENVI_IMAGE, FName, HEADER

  IF NOT FILE_TEST(FName)THEN BEGIN
    MESSAGE, "Image filename provided does not exist"
  ENDIF

  ImageData = $
  READ_BINARY(FName, $
    DATA_DIMS=(header.bands*header.samples*header.lines), $
    DATA_TYPE = header.data_type, $
    DATASTART = header.header_offset)
  
  ;依据存储顺序, 在元素总个数不变的前提下, 更改ImageData数组维数
  CASE header.interleave OF
    "bsq":ImageData = $
      REFORM(ImageData, header.samples, header.lines, header.bands)
    "bil": ImageData = $
      REFORM(ImageData, header.samples, header.bands, header.lines)
    "bip":ImageData = $
      REFORM(Imagedata, header.bands, header.samples, header.lines)
  ENDCASE
  ;读取存储图像数据的多维数组
  RETURN, ImageData
END
