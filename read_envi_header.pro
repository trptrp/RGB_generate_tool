; usage header = read_envi_header(headerFN)
function read_envi_header, headerFN
  ; open file
  OPENR, lun, headerFN, /GET_LUN
  ; define header structure
  header = { description:'', $
    samples:0L, $
    lines:0L, $;行数
    bands:0L, $；波段数
    header_offset:0L,$
    file_type:'', $ ;文件类型
    data_type:0L, $
    interleave:'', $;记录方式
    sensor_type:'', $;传感器类型
    wavelength_units:'', $;波长单位
    z_plot_range:[-1D, -1D], $
    z_plot_title:['', ''], $
    band_names:PTR_NEW(), $；波段名称
    wavelength:PTR_NEW() $
  }
  ;read file
  str = ''
  READF, lun, str
  str=STRTRIM(STRCOMPRESS(str), 2)
  IF (str NE "ENVI") THEN BEGIN
    MESSAGE, 'not a legal envi header file', /CONTINUE
    return, -1
  ENDIF

  WHILE NOT EOF(lun) DO BEGIN
    READF, lun, Str
    IF(STRLEN(str) GT 0 )THEN BEGIN
      
      ;read string and parse
      str = STRCOMPRESS(str)
      equalPosition = STRPOS(str, '=')
      IF (equalPosition GT 0) THEN BEGIN
        name = STRTRIM(STRMID(str, 0, equalPosition), 2)
        value = STRTRIM(STRMID(str, equalPosition+1), 2)
        multilineValue = STRTRIM(value, 2)
      ENDIF ELSE BEGIN
        multilineValue = multilineValue + '' + STRTRIM( str ,2)
      ENDELSE
      
      ; check if multiline
      IF(STRPOS(multilineValue,'{') NE -1) AND (STRPOS(multilineValue,'}') NE -1) $ 
      THEN BEGIN
        multilineComp1ete = 1
        multilineValue = STRTRIM(multilineValue, 2)
        multilineValue = STRMID(multilineValue, 1, STRLEN(multilineValue)-2)
      ENDIF ELSE BEGIN
        multilineComp1ete = 0
      ENDELSE
      
      ;结构体的成员变量赋值
      CASE STRLOWCASE(name) OF
        "description": IF multilineComp1ete $
          THEN header.description=multilineValue
        "samples":header.samples=FIX(value)
        "lines":header.lines=FIX(value)
        "bands":header.bands=FIX(value)
        "header offset":header.header_offset=FIX(value)
        "file type":header.file_type = value
        "data type":header.data_type=FIX(value)
        "interleave":header.interleave=STRLOWCASE(value)
        "sensort ype":header.sensor_type=value
        "wavelength units":header.wavelength_units=value
        "z plot range": IF multilineComp1ete $
          THEN header.z_plot_range=DOUBLE(STRSPLIT(mu1ti1ineValue, ',', /EXTRACT))
        "z plot titles": IF multilineComplete $
          THEN header.zplot_titles=STRSPLIT(mu1ti1ineValue, ',', /EXTRACT)
        "band names":IF multilineComp1ete $
          THEN header.bandnames = PTR_NEW(STRSPLIT(multilineValue, ',', /EXTRACT))
        "wavelength":IF multilineComp1ete $
          THEN header.wavelength = PTR_NEW(FLOAT(STRSPLIT(multilineValue, ',', /EXTRACT)))
        ELSE:
      ENDCASE
    ENDIF
  ENDWHILE
  ; read complete
  FREE_LUN, lun
  
  RETURN, header
END
