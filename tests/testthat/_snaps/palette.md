# palette creation work

    Code
      color_palette(c("firetruck", "ocean"))
    Condition
      Error in `color_palette()`:
      ! `pal` must be valid hexadecimal values or from `colors()`.
      i Problematic values: "firetruck" and "ocean".
    Code
      color_palette(c("#00ZVPQ", "#IOBNOB"))
    Condition
      Error in `color_palette()`:
      ! `pal` must be valid hexadecimal values or from `colors()`.
      i Problematic values: "#00ZVPQ" and "#IOBNOB".
    Code
      color_palette(c("#00ZVPQ", "red"))
    Condition
      Error in `color_palette()`:
      ! `pal` must be valid hexadecimal values or from `colors()`.
      i Problematic value: "#00ZVPQ".

# various formatting works

    Code
      df1
    Output
      # A tibble: 5 x 2
        red     evermore
        <clpal> <clpal> 
      1 #201F39 #160E10 
      2 #A91E47 #421E18 
      3 #7E6358 #D37F55 
      4 #B0A49A #85796D 
      5 #DDD8C9 #E0D9D7 

---

    Code
      album_palettes$lover
    Output
      <color_palette[5]>
          #76BAE0 
          #8C4F66 
          #B8396B 
          #EBBED3 
          #FFF5CC 

---

    Code
      album_palettes$folklore
    Output
      <color_palette[5]>
          #3E3E3E 
          #545454 
          #5C5C5C 
          #949494 
          #EBEBEB 

---

    Code
      color_palette(col1)
    Output
      <color_palette[3]>
          wheat 
          firebrick 
          navy 
    Code
      color_palette(col2)
    Output
      <color_palette[3]>
          #009fb7 
          #fed766 
          #696773 
    Code
      color_palette(col3)
    Output
      <color_palette[2]>
          goldenrod 
          #85898a 
    Code
      color_palette(col4)
    Output
      <color_palette[3]>
          ku_blue 
          ku_crimson 
          #ffc82d 

