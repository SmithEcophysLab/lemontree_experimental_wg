## Install packages
## install.packages()

## Load libraries
library(rpmodel)
library(dplyr)
library(tidyverse)
library(R.utils)

## Import ancillary optimal_vcmax_R functions. Note: must pre-load 
## functions for calc_optimal_vcmax to work. This is done below through the
## "sourceDirectory" function. You'll want to congregate your local path to 
## the optimal_vcmax_R functions subfolder, instead of the path I've provided 
## here
sourceDirectory("/Users/eaperkowski/git/optimal_vcmax_R/functions",
                modifiedOnly = FALSE)

## Load calc_optimal_vcmax function. You'll want to update with your local
## path to the 
source("/Users/eaperkowski/git/optimal_vcmax_R/calc_optimal_vcmax.R")

## Test calc_optimal_vcmax function across beta values at ambient CO2
df.420 <- calc_optimal_vcmax(ca = 420, beta = seq(100, 200, 5))
head(df.420)

## Test calc_optimal_vcmax function across beta values at 1000 ppm CO2
df.1000 <- calc_optimal_vcmax(ca = 1000, beta = seq(100, 200, 5))
head(df.1000)

## Join df.420 and df.1000 for plotting purposes
df <- df.420 %>%
  full_join(df.1000)

## Plot model simulations with beta on x-axis, any desireable trait on y-axis,
## with colored lines representing two CO2 levels
ggplot(data = df, aes(x = beta, y = vcmax25, color = as.factor(cao))) +
  geom_line(size = 2) +
  labs(x = "β (relative cost to use nutrients vs. water)",
       y = expression("V"["cmax25"]~"(μmol m"^"-2"~"s"^"-1"~")"),
       color = expression("CO"[2])) +
  theme_bw(base_size = 16)

ggplot(data = df, aes(x = beta, y = chi, color = as.factor(cao))) +
  geom_line(size = 2) +
  labs(x = "β (relative cost to use nutrients vs. water)",
       y = expression(chi),
       color = expression("CO"[2])) +
  theme_bw(base_size = 16)

## Note: can also modify other ancillary inputs to P-model 
## (e.g., using annual growing season temp as tg_c input)