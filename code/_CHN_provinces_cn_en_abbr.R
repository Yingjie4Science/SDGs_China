

# ## set work dir
path <- rstudioapi::getSourceEditorContext()$path
dir  <- dirname(rstudioapi::getSourceEditorContext()$path); dir
setwd(dir)

txt <- './_CHN_provinces_cn_en_abbr.txt'

df <- read.csv(txt, 
               encoding = 'UTF-8',
               # fileEncoding = 'UTF-8',
               sep = ';')
names(df)
names(df) <- c('name_cn', 'name_en', 'name_abbr', 'notes')

write.csv(x = df, file = './_CHN_provinces_cn_en_abbr.csv', fileEncoding = 'UTF-8')
