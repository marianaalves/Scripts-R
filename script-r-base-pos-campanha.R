#######################################################################################
# Script de extração de dados no Google Analytics                                     #
# Criado por: Digital Analytics e Marketing Cloud                                     #
# Autor: Mariana Alves                                                                #
# Data de Criação: 12/09/2017                                                         #
# Alterado por:                                                                       #
# Data de Alteração:                                                                  #
# Resumo da alteração:                                                                #
#######################################################################################

#Pacotes requeridos:
if(!require(RGoogleAnalytics)) install.packages("RGoogleAnalytics", dependencies = TRUE)

#Chamando o pacote
knitr::opts_chunk$set(echo = TRUE)
library(googleAnalyticsR)
library(googleAuthR)
library(shiny)

#######################################################################################
#                                                                                     #
#             A credencial abaixo é valida apenas para extrações com o R              #
#                                                                                     #
#######################################################################################

#Autenticador via Aouth
#Entre em contato conosco para obter o client id e o client secret.
client.id <- ""
client.secret <- ""

options(googleAuthR.client_id = client.id)
options(googleAuthR.client_secret = client.secret)
options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/analytics")

#Ao executar esse comando, abrirá uma página no seu browser que será necessário autenticar com seu usuário e senha do Analytics
token <- Auth(client.id,client.secret)

#Autenticacao
ga_auth()
#aparecerá no console a autenticação semelhante a:
#Token cache file: .httr-oauth
#2017-09-11 18:05:58> Authenticated


#Pega uma lista de metricas e dimensoes que podem ser usadas
meta <- google_analytics_meta()

#Informando a view do Google Analytics onde será puxado os dados
#133362104 -> LP Multivivo + modal
idViewGA <- 133362104

#Datas
d_inicio <- "2017-09-04"
d_fim <- "2017-09-04"

#Filtros -> Inserir todos os filtros aqui em variáveis diferentes
f_host <- dim_filter("hostname","REGEXP",".vivo.com.br")
f_country <- dim_filter("country","REGEXP","brazil")
f_pageSku <- dim_filter("pagePath","PARTIAL", "?sku=")
f_pagePedido <- dim_filter("pagePath","REGEXP", "/pedido")
f_pageParabens <- dim_filter("pagePath","REGEXP", "/parabens")
dim_filter()


#Criando a coleta dos dados

#Visitas Pós
#Filtros dessa consulta
f_visitasPos <- filter_clause_ga4(list(f_host, f_country), operator = "AND")

#Consulta
ga_visitaPos <- google_analytics_4(idViewGA, 
                                   date_range = c(d_inicio,d_fim), 
                                   metrics = c("sessions"), 
                                   dimensions = c("date",
                                                  "city",
                                                  "region",
                                                  "medium",
                                                  "campaign",
                                                  "channelGrouping"),
                                   dim_filters = f_visitasPos,
                                   anti_sample = TRUE)

#Abertura Modal

#Filtros dessa consulta
f_aberturaModal <- filter_clause_ga4(list(f_country, f_pageSku), operator = "AND")

#Consulta
ga_aberturaModal <- google_analytics_4(idViewGA, 
                                       date_range = c(d_inicio,d_fim), 
                                       metrics = c("uniquePageviews"), 
                                       dimensions = c("date",
                                                      "city",
                                                      "region",
                                                      "medium",
                                                      "campaign",
                                                      "channelGrouping"),
                                       dim_filters = f_aberturaModal,
                                       anti_sample = TRUE)

#Filtros dessa consulta
f_dadosPessoais <- filter_clause_ga4(list(f_country, f_pagePedido), operator = "AND")

#Consulta
ga_dadosPessoais <- google_analytics_4(idViewGA, 
                                       date_range = c(d_inicio,d_fim), 
                                       metrics = c("uniquePageviews"), 
                                       dimensions = c("date",
                                                      "city",
                                                      "region",
                                                      "medium",
                                                      "campaign",
                                                      "channelGrouping"),
                                       dim_filters = f_dadosPessoais,
                                       anti_sample = TRUE)

#Filtros dessa consulta
f_confirmacaoParabens <- filter_clause_ga4(list(f_country, f_pageParabens), operator = "AND")

#Consulta
ga_confirmacaoParabens <- google_analytics_4(idViewGA, 
                                             date_range = c(d_inicio,d_fim), 
                                             metrics = c("uniquePageviews"), 
                                             dimensions = c("date",
                                                            "city",
                                                            "region",
                                                            "medium",
                                                            "campaign",
                                                            "channelGrouping"),
                                             dim_filters = f_confirmacaoParabens,
                                             anti_sample = TRUE)

#######################################################################################
#                                                                                     #
#                                     IMPORTANTE                                      #
#                                                                                     #
#                                                                                     #
# Caso ocorra algum retorno de erro na API checar no link abaixo o tipo de erro:      #
# https://developers.google.com/analytics/devguides/reporting/core/v4/errors?hl=pt-br #
#                                                                                     #
# O erro 500 informa que ocorreu um erro interno do servidor inesperado, neste caso   #
# não execute o script novamente e aguarde alguns minutos para tentar novamente.      #
# Esse erro indica instabilidade com a API.                                           #
#                                                                                     #
# Caso ocorra outro erro entre em contato com o time de Digital Analytics e Marketing #
# cloud através do e-mail: digitalanalytics@telefonica.com.                           #
#                                                                                     #
#######################################################################################


#Referencias de dimensoes e metricas no Google Analytics
#https://developers.google.com/analytics/devguides/reporting/core/dimsmets

#Referencias sobre o pacote
#http://code.markedmondson.me/googleAnalyticsR/v4.html