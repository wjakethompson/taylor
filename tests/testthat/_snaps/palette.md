# various formatting works

    Code
      df1 <- tibble::tibble(red = album_palettes$red, evermore = album_palettes$
        evermore)
      print(df1)
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
      print(album_palettes$lover)
    Output
      <color_palette[5]>
          #76BAE0 
          #8C4F66 
          #B8396B 
          #EBBED3 
          #FFF5CC 
    Code
      print(album_palettes$folklore)
    Output
      <color_palette[5]>
          #3E3E3E 
          #545454 
          #5C5C5C 
          #949494 
          #EBEBEB 

---

    Code
      col1 <- c("wheat", "firebrick", "navy")
      col2 <- c("#009fb7", "#fed766", "#696773")
      col3 <- c("goldenrod", "#85898a")
      col4 <- c(ku_blue = "#0051ba", ku_crimson = "#e8000d", "#ffc82d")
      pal1 <- color_palette(col1)
      pal2 <- color_palette(col2)
      pal3 <- color_palette(col3)
      pal4 <- color_palette(col4)
      print(pal1)
    Output
      <color_palette[3]>
          wheat 
          firebrick 
          navy 
    Code
      print(pal2)
    Output
      <color_palette[3]>
          #009fb7 
          #fed766 
          #696773 
    Code
      print(pal3)
    Output
      <color_palette[2]>
          goldenrod 
          #85898a 
    Code
      print(pal4)
    Output
      <color_palette[3]>
          ku_blue 
          ku_crimson 
          #ffc82d 

