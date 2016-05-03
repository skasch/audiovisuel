options(java.parameters = "-Xmx1024m")
if (file.exists('../lib')) {
    .libPaths(c(.libPaths(), '../lib'))
}
library(shiny)
library(stringr)
library(dplyr)
library(magrittr)