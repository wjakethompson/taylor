suppressPackageStartupMessages(library(ggplot2))

test_that("discrete fill works", {
  fill_base <- ggplot(mpg, aes(manufacturer, fill = manufacturer)) +
    geom_bar(show.legend = FALSE) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  taylor_swift <- fill_base +
    scale_fill_taylor_d(album = "Taylor Swift")

  fearless <- fill_base +
    scale_fill_taylor_d(album = "Fearless")

  fearless_tv <- fill_base +
    scale_fill_taylor_d(album = "Fearless (Taylor's Version)")

  speak_now <- fill_base +
    scale_fill_taylor_d(album = "speak_now")

  red <- fill_base +
    scale_fill_taylor_d(album = "Red")

  red_tv <- fill_base +
    scale_fill_taylor_d(album = "Red (Taylor's Version)")

  `1989` <- fill_base +
    scale_fill_taylor_d(album = "1989")

  reputation <- fill_base +
    scale_fill_taylor_d(album = "reputation")

  lover <- fill_base +
    scale_fill_taylor_d(album = "lover")

  folklore <- fill_base +
    scale_fill_taylor_d(album = "folklore")

  evermore <- fill_base +
    scale_fill_taylor_d(album = "evermore")

  midnights <- fill_base +
    scale_fill_taylor_d(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-fill-d", taylor_swift)
  vdiffr::expect_doppelganger("fearless-fill-d", fearless)
  vdiffr::expect_doppelganger("fearless-tv-fill-d", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-fill-d", speak_now)
  vdiffr::expect_doppelganger("red-fill-d", red)
  vdiffr::expect_doppelganger("red-tv-fill-d", red_tv)
  vdiffr::expect_doppelganger("1989-fill-d", `1989`)
  vdiffr::expect_doppelganger("reputation-fill-d", reputation)
  vdiffr::expect_doppelganger("lover-fill-d", lover)
  vdiffr::expect_doppelganger("folklore-fill-d", folklore)
  vdiffr::expect_doppelganger("evermore-fill-d", evermore)
  vdiffr::expect_doppelganger("midnights-fill-d", midnights)
})

test_that("discrete color works", {
  color_base <- ggplot(mpg, aes(x = hwy, y = displ, color = factor(cyl))) +
    geom_point(size = 4, show.legend = FALSE) +
    theme_minimal()

  taylor_swift <- color_base +
    scale_color_taylor_d(album = "Taylor Swift")

  fearless <- color_base +
    scale_color_taylor_d(album = "Fearless")

  fearless_tv <- color_base +
    scale_color_taylor_d(album = "Fearless (Taylor's Version)")

  speak_now <- color_base +
    scale_color_taylor_d(album = "speak_now")

  red <- color_base +
    scale_color_taylor_d(album = "Red")

  red_tv <- color_base +
    scale_color_taylor_d(album = "Red (Taylor's Version)")

  `1989` <- color_base +
    scale_color_taylor_d(album = "1989")

  reputation <- color_base +
    scale_color_taylor_d(album = "reputation")

  lover <- color_base +
    scale_color_taylor_d(album = "lover")

  folklore <- color_base +
    scale_color_taylor_d(album = "folklore")

  evermore <- color_base +
    scale_color_taylor_d(album = "evermore")

  midnights <- color_base +
    scale_color_taylor_d(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-color-d", taylor_swift)
  vdiffr::expect_doppelganger("fearless-color-d", fearless)
  vdiffr::expect_doppelganger("fearless-tv-color-d", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-color-d", speak_now)
  vdiffr::expect_doppelganger("red-color-d", red)
  vdiffr::expect_doppelganger("red-tv-color-d", red_tv)
  vdiffr::expect_doppelganger("1989-color-d", `1989`)
  vdiffr::expect_doppelganger("reputation-color-d", reputation)
  vdiffr::expect_doppelganger("lover-color-d", lover)
  vdiffr::expect_doppelganger("folklore-color-d", folklore)
  vdiffr::expect_doppelganger("evermore-color-d", evermore)
  vdiffr::expect_doppelganger("midnights-color-d", midnights)
})

test_that("continuous fill works", {
  x <- expand.grid(group = 1:10, big = LETTERS)
  x$value <- c(1.444, 0.968, 2.112, 0.956, -0.25, -0.864, 0.373, 1.073, 2.414,
               1.699, 0.659, 0.325, 0.474, -0.374, 0.282, 0.035, 1.967, 0.107,
               0.88, 0.141, 0.565, 2.306, 1.115, 0.85, 0.764, 0.724, 2.069,
               1.578, 1.698, 2.594, 1.72, 0.899, 1.82, 0.747, 1.217, 2.747,
               1.715, 0.909, 2.146, 2.32, 2.478, 3.834, 1.883, 2.531, 1.632,
               2.192, 2.998, 1.604, 3.214, 3.15, 1.769, 1.976, 3.697, 3.32,
               3.46, 5.304, 3.757, 1.722, 1.791, 2.789, 3.352, 4.331, 3.427,
               2.883, 2.688, 2.563, 2.35, 2.348, 3.326, 3.806, 4.975, 3.713,
               3.643, 1.777, 3.754, 3.567, 2.858, 3.076, 4.62, 3.143, 5.639,
               2.171, 3.92, 2.9, 4.154, 4.526, 5.672, 6.238, 4.007, 3.023, 3.24,
               4.346, 2.74, 4.747, 4.439, 4.479, 3.922, 3.649, 4.682, 4.834,
               3.722, 4.567, 4.523, 4.28, 4.081, 3.705, 6.567, 4.558, 5.598,
               5.596, 5.059, 4.307, 4.574, 5.423, 5.199, 6.24, 5.58, 4.645,
               4.548, 4.457, 6.019, 5.64, 4.93, 5.922, 4.738, 5.639, 6.707,
               5.485, 4.943, 5.155, 5.454, 5.075, 6.488, 6.405, 6.649, 5.643,
               6.52, 6.463, 5.642, 7.437, 6.249, 6.343, 5.162, 6.185, 3.179,
               5.374, 7.599, 6.628, 4.51, 4.894, 5.31, 5.961, 6.753, 6.409,
               6.241, 7.538, 6.191, 7.031, 6.999, 6.917, 6.807, 8.068, 9.055,
               8.982, 6.674, 5.749, 7.78, 7.259, 7.007, 8.184, 5.455, 7.642,
               6.314, 7.055, 7.908, 6.243, 6.718, 6.635, 6.525, 8.927, 6.877,
               8.46, 8.209, 8.835, 8.139, 8.107, 7.174, 8.346, 8.086, 7.885,
               8.407, 6.046, 7.878, 10.094, 8.744, 7.468, 8.261, 9.056, 7.968,
               9.438, 8.679, 8.788, 7.769, 6.845, 8.033, 7.471, 8.478, 8.954,
               8.844, 10.55, 8.573, 8.079, 9.941, 8.441, 7.96, 10.778, 8.365,
               8.524, 8.101, 8.333, 9.243, 9.537, 9.353, 8.735, 9.228, 10.151,
               8.581, 7.638, 8.683, 9.721, 10.966, 8.768, 9.543, 9.419, 9.362,
               13.266, 10.891, 10.559, 10.146, 9.942, 10.717, 9.558, 9.811,
               12.01, 9.957, 10.121, 9.596, 8.748, 11.619, 9.822, 9.792, 11.099,
               9.737, 11.405, 9.045, 12.137, 12.151, 11.411, 7.363, 8.803)

  fill_base <- ggplot(x, aes(x = group, y = big, fill = value)) +
    geom_tile() +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) +
    coord_equal() +
    labs(x = NULL, y = NULL)

  taylor_swift <- fill_base +
    scale_fill_taylor_c(album = "Taylor Swift")

  fearless <- fill_base +
    scale_fill_taylor_c(album = "Fearless")

  fearless_tv <- fill_base +
    scale_fill_taylor_c(album = "Fearless (Taylor's Version)")

  speak_now <- fill_base +
    scale_fill_taylor_c(album = "speak_now")

  red <- fill_base +
    scale_fill_taylor_c(album = "Red")

  red_tv <- fill_base +
    scale_fill_taylor_c(album = "Red (Taylor's Version)")

  `1989` <- fill_base +
    scale_fill_taylor_c(album = "1989")

  reputation <- fill_base +
    scale_fill_taylor_c(album = "reputation")

  lover <- fill_base +
    scale_fill_taylor_c(album = "lover")

  folklore <- fill_base +
    scale_fill_taylor_c(album = "folklore")

  evermore <- fill_base +
    scale_fill_taylor_c(album = "evermore")

  midnights <- fill_base +
    scale_fill_taylor_c(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-fill-c", taylor_swift)
  vdiffr::expect_doppelganger("fearless-fill-c", fearless)
  vdiffr::expect_doppelganger("fearless-tv-fill-c", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-fill-c", speak_now)
  vdiffr::expect_doppelganger("red-fill-c", red)
  vdiffr::expect_doppelganger("red-tv-fill-c", red_tv)
  vdiffr::expect_doppelganger("1989-fill-c", `1989`)
  vdiffr::expect_doppelganger("reputation-fill-c", reputation)
  vdiffr::expect_doppelganger("lover-fill-c", lover)
  vdiffr::expect_doppelganger("folklore-fill-c", folklore)
  vdiffr::expect_doppelganger("evermore-fill-c", evermore)
  vdiffr::expect_doppelganger("midnights-fill-c", midnights)
})

test_that("continuous color works", {
  rows <- c(42906L, 29053L, 17099L, 41367L, 19970L, 15440L, 16278L, 49329L,
            36002L, 10465L, 4302L, 33202L, 42126L, 8045L, 7178L, 22773L,
            28855L, 1011L, 36524L, 15059L, 33834L, 25371L, 45086L, 49570L,
            38595L, 46449L, 7126L, 32472L, 1968L, 47250L, 28086L, 10539L,
            43919L, 33541L, 11499L, 10526L, 42307L, 20126L, 53326L, 48701L,
            2980L, 34727L, 51505L, 25786L, 40502L, 50793L, 27999L, 21306L,
            8116L, 26851L, 38032L, 15703L, 35785L, 13070L, 47743L, 27241L,
            5462L, 8594L, 11853L, 19206L, 4474L, 49577L, 20462L, 15379L,
            6484L, 42173L, 44012L, 21155L, 41592L, 50079L, 9687L, 48251L,
            28979L, 32772L, 7652L, 34333L, 28497L, 5418L, 39763L, 18434L,
            32773L, 4467L, 50228L, 37884L, 22789L, 53622L, 11040L, 44830L,
            17062L, 8003L, 13653L, 19553L, 20981L, 26989L, 48334L, 6082L,
            3207L, 6883L, 13684L, 16640L, 21954L, 53647L, 46872L, 14382L,
            5034L, 33986L, 45655L, 41819L, 48022L, 7358L, 17449L, 50183L,
            52717L, 36671L, 4161L, 26017L, 4012L, 21829L, 45402L, 23729L,
            27933L, 35408L, 3823L, 49866L, 51286L, 22498L, 20960L, 20886L,
            36324L, 32966L, 43624L, 33003L, 2937L, 41368L, 14945L, 19109L,
            3180L, 633L, 37500L, 53789L, 21241L, 47399L, 28929L, 24331L,
            26238L, 11134L, 37186L, 33593L, 8071L, 10358L, 26112L, 53480L,
            42770L, 15015L, 28167L, 25260L, 48932L, 13051L, 39290L, 9936L,
            37425L, 2720L, 21647L, 49820L, 41176L, 53916L, 29099L, 42781L,
            2574L, 51470L, 28267L, 2599L, 29531L, 48054L, 30369L, 34145L,
            37209L, 47011L, 24739L, 29807L, 4514L, 6691L, 11624L, 31090L,
            12187L, 15189L, 9937L, 32679L, 44561L, 20838L, 6549L, 5197L,
            10750L, 22596L, 51939L, 52099L, 12904L, 51185L, 6989L, 8760L,
            38695L, 38235L, 38058L, 29947L, 28331L, 27747L, 6139L, 33794L,
            50235L, 13659L, 19564L, 44160L, 27056L, 30971L, 10341L, 47439L,
            39320L, 17127L, 30672L, 49515L, 27766L, 37157L, 6145L, 45657L,
            13478L, 46085L, 5619L, 8686L, 24012L, 42169L, 8286L, 15135L,
            25437L, 34483L, 14051L, 34659L, 45900L, 20873L, 18613L, 24813L,
            10036L, 23280L, 14146L, 36218L, 44399L, 25831L, 51435L, 53254L,
            15505L, 51846L, 6098L, 2099L, 1247L, 28059L, 23119L, 2584L, 10949L,
            15434L, 5987L, 21124L, 11290L, 19871L, 42755L, 14337L, 37462L,
            27761L, 41151L, 35180L, 1271L, 32393L, 19186L, 33212L, 7926L,
            12148L, 16446L, 36851L, 41382L, 7333L, 3985L, 21945L, 3147L,
            14026L, 38567L, 9036L, 35884L, 5435L, 15941L, 2708L, 2357L, 27699L,
            51571L, 18084L, 49787L, 19437L, 18891L, 255L, 6333L, 40752L,
            34758L, 22790L, 2763L, 13924L, 46447L, 2219L, 23294L, 44238L,
            36574L, 24301L, 40702L, 7742L, 39592L, 31057L, 21862L, 1700L,
            29424L, 30206L, 14310L, 3861L, 3034L, 25063L, 50817L, 12909L,
            37571L, 32251L, 6308L, 29896L, 16191L, 7174L, 11452L, 28238L,
            7448L, 35681L, 50578L, 27377L, 14172L, 43501L, 46153L, 3878L,
            8742L, 46747L, 43296L, 2418L, 32240L, 50010L, 22179L, 44584L,
            31586L, 5276L, 10886L, 6073L, 17115L, 8454L, 10620L, 46841L,
            43489L, 50318L, 32825L, 49772L, 28150L, 47132L, 35746L, 46757L,
            6274L, 46271L, 13617L, 7918L, 37491L, 29989L, 26436L, 49460L,
            9549L, 30537L, 20311L, 9082L, 48121L, 49903L, 49388L, 47422L,
            47026L, 30936L, 36968L, 31930L, 50782L, 26213L, 14282L, 40891L,
            33029L, 47281L, 23354L, 42872L, 26900L, 48384L, 13375L, 25888L,
            11082L, 27721L, 49711L, 39038L, 28033L, 30542L, 31127L, 13917L,
            44958L, 49720L, 9981L, 51714L, 23846L, 7073L, 45539L, 32611L,
            7612L, 5287L, 6768L, 5318L, 18585L, 11137L, 52287L, 25476L, 17021L,
            91L, 22849L, 1025L, 27410L, 40086L, 8789L, 10079L, 6863L, 35965L,
            28299L, 27268L, 36623L, 51437L, 33058L, 25816L, 24870L, 44106L,
            26782L, 11859L, 38107L, 8325L, 46870L, 43519L, 3951L, 23579L,
            38343L, 33343L, 44722L, 22934L, 44448L, 14668L, 23503L, 18741L,
            4503L, 1565L, 45304L, 25094L, 22L, 5000L, 34569L, 45027L, 10134L,
            9578L, 21026L, 37963L, 24576L, 16262L, 23577L, 8712L, 48156L,
            27681L, 8328L, 12195L, 51738L, 50909L, 39527L, 35747L, 18807L,
            6638L, 19589L, 7074L, 18488L, 25790L, 13255L, 27951L, 6735L,
            48519L, 35613L, 52681L, 36992L, 46460L, 33149L, 46368L, 28717L,
            41872L, 26394L, 24062L, 20191L, 44844L, 26131L, 21523L, 47310L,
            831L, 14985L, 33437L, 37793L, 4789L, 24494L, 17096L, 34441L,
            9823L, 42097L, 12890L, 3014L, 42841L, 4703L, 34093L, 41991L,
            17246L, 4760L, 16356L, 15207L, 52581L, 7281L, 43668L, 27822L,
            1265L, 41779L, 20842L, 29286L, 48975L, 16195L, 49107L, 34711L,
            38308L, 52907L, 1108L, 21600L, 45927L, 44567L, 41929L, 30460L,
            9218L, 35974L, 10807L, 44819L, 1376L, 33825L, 21214L, 17256L,
            2063L, 30493L, 20581L, 19463L, 29857L, 1450L, 30188L, 3544L,
            1745L, 28295L, 14883L, 14188L, 29905L, 29399L, 11516L, 27311L,
            17143L, 41827L, 8514L, 27143L, 11444L, 49284L, 3122L, 12236L,
            39760L, 21684L, 49353L, 41623L, 50528L, 14410L, 38326L, 47922L,
            52334L, 35881L, 24178L, 7332L, 18367L, 44007L, 15550L, 8620L,
            7343L, 35528L, 2236L, 52059L, 48683L, 16444L, 19022L, 21559L,
            25061L, 522L, 50099L, 23164L, 48093L, 41134L, 2662L, 21055L,
            6985L, 40988L, 32983L, 21573L, 33452L, 27885L, 19853L, 26548L,
            18374L, 41720L, 44161L, 20653L, 15373L, 30097L, 41247L, 22151L,
            5741L, 13449L, 42331L, 39421L, 53599L, 40141L, 40259L, 29035L,
            45832L, 47551L, 35891L, 29439L, 16942L, 22443L, 49647L, 4615L,
            42986L, 23339L, 13061L, 45003L, 46011L, 10623L, 10442L, 8327L,
            32170L, 12711L, 9374L, 3252L, 50025L, 34243L, 21518L, 36538L,
            24133L, 11719L, 46472L, 46575L, 30173L, 30234L, 39488L, 50386L,
            5292L, 23058L, 28841L, 49827L, 46588L, 14053L, 36020L, 39916L,
            33174L, 40174L, 847L, 34187L, 40941L, 48335L, 53149L, 8317L,
            45939L, 19698L, 50691L, 5693L, 25765L, 17634L, 42497L, 47007L,
            37693L, 30700L, 30481L, 31936L, 48494L, 35011L, 53840L, 47479L,
            5535L, 31893L, 27161L, 12673L, 39071L, 20022L, 25327L, 12821L,
            42895L, 16557L, 43559L, 35297L, 29158L, 14300L, 40746L, 45405L,
            9755L, 31785L, 7267L, 12518L, 29737L, 27426L, 31317L, 31869L,
            8163L, 21958L, 9852L, 51256L, 7311L, 51813L, 28304L, 10078L,
            27670L, 41651L, 36587L, 33679L, 23648L, 4923L, 11756L, 23550L,
            3960L, 26806L, 51142L, 48284L, 42291L, 50356L, 15750L, 39837L,
            47426L, 33228L, 1438L, 2243L, 15102L, 2452L, 24221L, 33116L,
            45835L, 50105L, 6206L, 2644L, 14019L, 40246L, 33705L, 50643L,
            21596L, 26518L, 30710L, 49675L, 28891L, 48348L, 36482L, 6413L,
            1343L, 19472L, 9369L, 43560L, 42623L, 9004L, 20866L, 27986L,
            31375L, 49369L, 19623L, 520L, 41185L, 47348L, 16790L, 40351L,
            18779L, 27089L, 18180L, 7338L, 10933L, 34240L, 18220L, 44668L,
            46691L, 15204L, 29752L, 8362L, 21329L, 40197L, 36237L, 43620L,
            7169L, 12903L, 32491L, 29225L, 38765L, 37869L, 40326L, 26475L,
            42822L, 9294L, 1901L, 27122L, 14079L, 23927L, 28009L, 23952L,
            53464L, 2823L, 5325L, 21660L, 17202L, 35741L, 12458L, 42244L,
            39163L, 25040L, 45729L, 20971L, 17620L, 32980L, 26729L, 9666L,
            11806L, 124L, 44873L, 32317L, 39082L, 25019L, 36389L, 44822L,
            6169L, 13722L, 43989L, 13709L, 20544L, 39875L, 6306L, 14671L,
            27129L, 32817L, 21363L, 1021L, 4975L, 33690L, 47646L, 27363L,
            12455L, 27308L, 5869L, 18311L, 47966L, 49114L, 4187L, 43408L,
            31344L, 40149L, 11368L, 9029L, 33732L, 37014L, 51619L, 27980L,
            33295L, 29788L, 13448L, 15325L, 53473L, 28200L, 14462L, 4156L,
            40137L, 27019L, 39619L, 11449L, 43499L, 20790L, 5772L, 45543L,
            28625L, 40971L, 53570L, 21341L, 9757L, 1811L, 7763L, 17903L,
            10925L, 32576L, 15850L, 29429L, 2912L, 26302L, 35276L, 53172L,
            43484L, 557L, 28553L, 20616L, 14634L, 42504L, 22745L, 14253L,
            1736L, 21029L, 15148L, 16745L, 11794L, 20872L, 25324L, 38201L,
            35733L, 7346L, 8347L, 46632L, 40834L, 22901L, 43755L, 46223L,
            7815L, 1045L, 1953L, 24872L, 7924L, 33812L, 51029L, 43576L, 53569L,
            37835L, 2070L, 40996L, 28601L, 48735L, 22411L, 12668L, 33300L,
            8617L, 16467L, 36699L, 32516L, 20124L, 20868L, 19778L, 8272L,
            3657L, 52349L, 24841L, 30179L, 44233L, 47794L, 39790L, 40480L,
            43872L, 36080L, 26350L, 20204L, 39567L, 8822L, 31148L, 5579L,
            15609L, 222L, 11186L, 2113L, 26860L, 19026L, 15531L, 24910L,
            30611L, 34251L, 27099L, 21665L, 49855L, 16723L, 49275L, 4547L,
            11227L, 7368L, 14701L, 24279L, 36555L, 19226L, 15959L, 1156L,
            37442L, 20980L, 2217L, 17726L, 44098L, 26603L, 15092L, 23293L,
            44115L, 48103L)
  dsamp <- diamonds[rows, ]

  color_base <- ggplot(dsamp, aes(x = carat, y = price, color = carat)) +
    geom_point(size = 2) +
    theme_minimal()

  taylor_swift <- color_base +
    scale_color_taylor_c(album = "Taylor Swift")

  fearless <- color_base +
    scale_color_taylor_c(album = "Fearless")

  fearless_tv <- color_base +
    scale_color_taylor_c(album = "Fearless (Taylor's Version)")

  speak_now <- color_base +
    scale_color_taylor_c(album = "speak_now")

  red <- color_base +
    scale_color_taylor_c(album = "Red")

  red_tv <- color_base +
    scale_color_taylor_c(album = "Red (Taylor's Version)")

  `1989` <- color_base +
    scale_color_taylor_c(album = "1989")

  reputation <- color_base +
    scale_color_taylor_c(album = "reputation")

  lover <- color_base +
    scale_color_taylor_c(album = "lover")

  folklore <- color_base +
    scale_color_taylor_c(album = "folklore")

  evermore <- color_base +
    scale_color_taylor_c(album = "evermore")

  midnights <- color_base +
    scale_color_taylor_c(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-color-c", taylor_swift)
  vdiffr::expect_doppelganger("fearless-color-c", fearless)
  vdiffr::expect_doppelganger("fearless-tv-color-c", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-color-c", speak_now)
  vdiffr::expect_doppelganger("red-color-c", red)
  vdiffr::expect_doppelganger("red-tv-color-c", red_tv)
  vdiffr::expect_doppelganger("1989-color-c", `1989`)
  vdiffr::expect_doppelganger("reputation-color-c", reputation)
  vdiffr::expect_doppelganger("lover-color-c", lover)
  vdiffr::expect_doppelganger("folklore-color-c", folklore)
  vdiffr::expect_doppelganger("evermore-color-c", evermore)
  vdiffr::expect_doppelganger("midnights-color-c", midnights)
})

test_that("binned fill works", {
  fill_base <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    labs(x = NULL, y = NULL)

  taylor_swift <- fill_base +
    scale_fill_taylor_b(album = "Taylor Swift")

  fearless <- fill_base +
    scale_fill_taylor_b(album = "Fearless")

  fearless_tv <- fill_base +
    scale_fill_taylor_b(album = "Fearless (Taylor's Version)")

  speak_now <- fill_base +
    scale_fill_taylor_b(album = "Speak Now")

  red <- fill_base +
    scale_fill_taylor_b(album = "Red")

  red_tv <- fill_base +
    scale_fill_taylor_b(album = "Red (Taylor's Version)")

  `1989` <- fill_base +
    scale_fill_taylor_b(album = "1989")

  reputation <- fill_base +
    scale_fill_taylor_b(album = "reputation")

  lover <- fill_base +
    scale_fill_taylor_b(album = "Lover")

  folklore <- fill_base +
    scale_fill_taylor_b(album = "folklore")

  evermore <- fill_base +
    scale_fill_taylor_b(album = "evermore")

  midnights <- fill_base +
    scale_fill_taylor_b(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-fill-b", taylor_swift)
  vdiffr::expect_doppelganger("fearless-fill-b", fearless)
  vdiffr::expect_doppelganger("fearless-tv-fill-b", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-fill-b", speak_now)
  vdiffr::expect_doppelganger("red-fill-b", red)
  vdiffr::expect_doppelganger("red-tv-fill-b", red_tv)
  vdiffr::expect_doppelganger("1989-fill-b", `1989`)
  vdiffr::expect_doppelganger("reputation-fill-b", reputation)
  vdiffr::expect_doppelganger("lover-fill-b", lover)
  vdiffr::expect_doppelganger("folklore-fill-b", folklore)
  vdiffr::expect_doppelganger("evermore-fill-b", evermore)
  vdiffr::expect_doppelganger("midnights-fill-b", midnights)
})

test_that("binned color work", {
  color_base <- ggplot(faithful, aes(eruptions, waiting)) +
    geom_point(aes(color = eruptions), size = 3) +
    theme_minimal()

  taylor_swift <- color_base +
    scale_color_taylor_b(album = "Taylor Swift")

  fearless <- color_base +
    scale_color_taylor_b(album = "Fearless")

  fearless_tv <- color_base +
    scale_color_taylor_b(album = "Fearless (Taylor's Version)")

  speak_now <- color_base +
    scale_color_taylor_b(album = "Speak Now")

  red <- color_base +
    scale_color_taylor_b(album = "Red")

  red_tv <- color_base +
    scale_color_taylor_b(album = "Red (Taylor's Version)")

  `1989` <- color_base +
    scale_color_taylor_b(album = "1989")

  reputation <- color_base +
    scale_color_taylor_b(album = "reputation")

  lover <- color_base +
    scale_color_taylor_b(album = "Lover")

  folklore <- color_base +
    scale_color_taylor_b(album = "folklore")

  evermore <- color_base +
    scale_color_taylor_b(album = "evermore")

  midnights <- color_base +
    scale_color_taylor_b(album = "midnights")

  vdiffr::expect_doppelganger("taylor-swift-color-b", taylor_swift)
  vdiffr::expect_doppelganger("fearless-color-b", fearless)
  vdiffr::expect_doppelganger("fearless-tv-color-b", fearless_tv)
  vdiffr::expect_doppelganger("speak-now-color-b", speak_now)
  vdiffr::expect_doppelganger("red-color-b", red)
  vdiffr::expect_doppelganger("red-tv-color-b", red_tv)
  vdiffr::expect_doppelganger("1989-color-b", `1989`)
  vdiffr::expect_doppelganger("reputation-color-b", reputation)
  vdiffr::expect_doppelganger("lover-color-b", lover)
  vdiffr::expect_doppelganger("folklore-color-b", folklore)
  vdiffr::expect_doppelganger("evermore-color-b", evermore)
  vdiffr::expect_doppelganger("midnights-color-b", midnights)
})

test_that("album scale works", {
  studio <- subset(taylor_albums, !ep)

  # no leveling
  no_level <- ggplot(studio, aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5) +
    scale_fill_albums() +
    scale_color_albums()

  # make albums a factor
  lvl_studio <- studio
  lvl_studio$album_name <- factor(lvl_studio$album_name, levels = album_levels)
  normal_level <- ggplot(lvl_studio,
                         aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5) +
    scale_fill_albums() +
    scale_color_albums()

  # reverse levels
  rlvl_studio <- studio
  rlvl_studio$album_name <- factor(rlvl_studio$album_name,
                                   levels = rev(album_levels))
  reverse_level <- ggplot(rlvl_studio,
                          aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5) +
    scale_fill_albums() +
    scale_color_albums()

  # random levels
  rand_studio <- studio
  new_levels <- c(seq(1, length(album_levels), by = 2),
                  seq(2, length(album_levels), by = 2))
  rand_studio$album_name <- factor(rand_studio$album_name,
                                   levels = album_levels[new_levels])
  rand_level <- ggplot(rand_studio, aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5) +
    scale_fill_albums() +
    scale_color_albums()

  # bad levels
  small_studio <- studio[c(1, 7, 2, 3, 5), ]
  beyonce <- rbind(small_studio, data.frame(album_name = "Lemonade",
                                            ep = FALSE,
                                            album_release = NA,
                                            metacritic_score = 92L,
                                            user_score = 8.0))

  # default bad label = blank
  miss1 <- ggplot(beyonce, aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5, na.rm = TRUE) +
    scale_fill_albums() +
    scale_color_albums()

  # red missing
  miss2 <- ggplot(beyonce, aes(x = metacritic_score, y = album_name)) +
    geom_col(aes(fill = album_name)) +
    geom_point(aes(fill = album_name, color = album_name),
               shape = 21, size = 5) +
    scale_fill_albums(na.value = "red") +
    scale_color_albums(na.value = "red")

  vdiffr::expect_doppelganger("albums-no-factor", no_level)
  vdiffr::expect_doppelganger("albums-correct-factor", normal_level)
  vdiffr::expect_doppelganger("albums-reverse-factor", reverse_level)
  vdiffr::expect_doppelganger("albums-random-factor", rand_level)
  vdiffr::expect_doppelganger("albums-blank-bad-label", miss1)
  vdiffr::expect_doppelganger("albums-specified-bad-label", miss2)
})
