# data frames are analyzed

    Code
      as.data.frame(dplyr::select(analyze_rhymes(dplyr::filter(taylor_all_songs,
        track_name %in% c("Tim McGraw", "Anti-Hero", "Karma")), pronunciation = "cmudict"),
      "track_name", "n_words":"longest_rhyme"))
    Output
        track_name n_words total_rhymes unique_rhymes rhyme_density
      1 Tim McGraw     214           40            36     0.3990610
      2  Anti-Hero     206           75            60     0.8536585
      3      Karma     230           51            40     0.4890830
        longest_rhyme_length
      1                    3
      2                    6
      3                    4
                                                     longest_rhyme
      1                         shame that night / said that's lie
      2 devices they come with prices vices / i end up in crisis i
      3                      to betrayal but / you'll see glare of

