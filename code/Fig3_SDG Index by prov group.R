

# To clear your environment 
remove(list = ls())

# set work dir
path <- rstudioapi::getSourceEditorContext()$path
dir  <- dirname(rstudioapi::getSourceEditorContext()$path); dir
setwd(dir)
setwd('../')
getwd()

dir.fig <- './Figures'
getwd()


# read dat
library(readxl)
library(tidyverse)
library(cowplot)
library(scales)
library(Rmisc) ## for `summarySE`

xls <- './data/Figure 3.xlsx'
df0 <- read_excel(path = xls, sheet = '2019 UPDATE', 
                  col_names = T, range = 'I1:O21') #, col_types = "numeric")
str(df0)
df1 <- df0 %>% gather(key = years, value = SDG, 4:7) %>%
  dplyr::mutate(year = as.numeric(gsub("\\D", "", years)))


levels(factor(df1$group_1))


err_1  <- df1 %>% dplyr::filter(group_2 != 'na') %>%
  summarySE(measurevar="SDG", groupvars=c("group_2","year"))
err_dd <- summarySE(df1, measurevar="SDG", groupvars=c("group_1","year"))

df1.1 <-  df1 %>% dplyr::filter(group_2 != 'na')

# df2 <- df1 %>%
#   dplyr::group_by(group_1, year) %>%
#   dplyr::summarise(mean(SDG, na.rm = TRUE))
# names(df2) <- c('group_1', 'year', 'SDG_mean')

mycol <-  scale_fill_manual(values=c("#9ecae1", "#6baed6", "#3182bd", "#08519c"))

p3_top <- 
  ggplot(data = err_1, aes(x=factor(group_2),
                           y=SDG, 
                           fill=factor(year))) +
  geom_bar(position = position_dodge(0.8), stat="identity", width = 0.8)+
  geom_errorbar(data = err_1, 
                aes(ymin=SDG-se, ymax=SDG+se), 
                width=.3, 
                position=position_dodge(.8)) +
  
  geom_point(data = df1.1,
             aes(x=factor(group_2),
                 y=SDG, 
                 fill=factor(year)),
             position=position_dodge(.8),
             # position=position_jitterdodge(0.05),
             alpha=0.3) +
  # geom_jitter(width=0.5, alpha=0.2) +
  ylab("SDG Index score")+ 
  xlab('')+
  labs(fill = "Year")+
  # ylim(30, 70)+
  scale_y_continuous(limits=c(30,70),oob = rescale_none)+
  
  # scale_fill_brewer(palette = "Blues", direction = 1) + 
  mycol+ 
  
  theme_bw() +
  # theme(legend.position = "none") +
  theme(legend.position = c(0.1, 0.85))
  
p3_top




p3_dd <- 
  ggplot(data = err_dd, 
         aes(x=factor(group_1, levels = c("developing provinces", "developed provinces")),
             y=SDG, fill=factor(year)))+
  # geom_col(width = 0.75, position = dodge)+
  geom_bar(position = position_dodge(0.8), stat="identity", width = 0.8)+
  
  # ggplot() +
  geom_errorbar(data = err_dd, 
                aes(
                  # x=factor(group_1, levels = c("developing provinces", "developed provinces")),
                  # y=SDG,
                  ymin=SDG-se, ymax=SDG+se), 
              
                width=.3, 
                # position=pd，
                position=position_dodge(.8)
                # position = dodge
                # position = position_dodge(0.7), stat="identity"
  ) +
  geom_point(data = df1,
             aes(x=factor(group_1, levels = c("developing provinces", "developed provinces")),
                 y=SDG, fill=factor(year)),
             position=position_dodge(.8),
             # position=position_jitterdodge(0.05),
             alpha=0.3) +
  
  ylab("")+ 
  xlab('')+
  labs(fill = "Year")+
  # ylim(30, 70)+
  scale_y_continuous(limits=c(30,70),oob = rescale_none)+
  # scale_fill_brewer(palette = "Blues", direction = 1) + 
  mycol+
  theme_bw() +
  theme(legend.position = "none") #+
  # theme(legend.position = c(0.86, 0.16))
# theme(axis.text.x = element_text(angle = 20, hjust = 1))
p3_dd



plot_grid(p3_top, p3_dd, labels = 'auto')


fname = './Figures/Figure 3.pdf'
ggsave(filename = fname, plot = last_plot(), width = 9, height = 5, units = 'in', dpi = 300)
