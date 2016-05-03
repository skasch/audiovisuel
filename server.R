shinyServer(function(input, output) {
  
  load('data/matos.RData')
  
  state <- reactiveValues()
  state$matos <- matos
  
  for (eqId in matos$equipment$id) {
    observeEvent(
      input[[str_c('delete_', eqId)]]
      ,{
        state$matos$equipment %<>% filter(id != eqId)
        print(state$matos)
        matos <- state$matos
        save(matos, file = 'data/matos.RData')
      }
    )
    
    observeEvent(
      input[[str_c('rent_', eqId)]]
      ,{
        state$matos$equipment$hasit[state$matos$equipment$id == eqId] <- 
          input[[str_c('renter_', eqId)]]
        print(state$matos)
        matos <- state$matos
        save(matos, file = 'data/matos.RData')
      }
    )
    
    observeEvent(
      input[[str_c('unlog_', eqId)]]
      ,{
        state$matos$equipment$hasit[state$matos$equipment$id == eqId] <- ''
        print(state$matos)
        matos <- state$matos
        save(matos, file = 'data/matos.RData')
      }
    )
  }
  
  # Update state
  observe({
    matos <- state$matos
    
    for (eqId in state$matos$equipment$id) {
      observeEvent(
        input[[str_c('delete_', eqId)]]
        ,{
          state$matos$equipment %<>% filter(id != eqId)
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
      
      observeEvent(
        input[[str_c('rent_', eqId)]]
        ,{
          state$matos$equipment$hasit[state$matos$equipment$id == eqId] <- 
            input[[str_c('renter_', eqId)]]
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
      
      observeEvent(
        input[[str_c('unlog_', eqId)]]
        ,{
          state$matos$equipment$hasit[state$matos$equipment$id == eqId] <- ''
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
    }
    
    # Save new state
    print(matos)
    save(matos, file = 'data/matos.RData')
  })

  observeEvent(input$createNewEquipment, {
    newId <- str_c(input$newEquipmentName %>% tolower %>% str_replace_all('[^a-z0-9]', '')
                   ,'_'
                   ,input$newEquipmentNumber)
    newEquipment <- data_frame(
      id = newId
      ,name = input$newEquipmentName
      ,category = input$newEquipmentCategory
      ,number = input$newEquipmentNumber
      ,hasit = ''
    )
    if (newEquipment$id[[1]] %in% state$matos$equipment$id) {
      return(NULL)
    }
    state$matos$equipment %<>% bind_rows(newEquipment)
  })
  
  observeEvent(input$createNewCategory, {
    newCategory <- data_frame(
      id = input$newCategoryName %>% tolower %>% str_replace_all('[^a-z0-9]', '')
      ,name = input$newCategoryName
    )
    if (newCategory$id[[1]] %in% state$matos$category$id) {
      return(NULL)
    }
    state$matos$category %<>% bind_rows(newCategory)
  })
  
  output$equipmentList <- renderUI({
    equipments <- state$matos$equipment
    if (is.null(equipments) || length(equipments) == 0) {
      return(NULL)
    } 
    equipTags <- equipments %>% rowwise %>% do(tag = {
      if (is.null(.$hasit) || .$hasit == '') {
        tags$div(
          fluidRow(
            column(
              4
              ,tags$h3(.$name)
              ,tags$p(.$category)
            )
            ,column(
              6
              ,textInput(str_c('renter_', .$id), 'Renter')
              ,actionButton(str_c('rent_', .$id), 'Rent')
            )
            ,column(
              2
              ,actionButton(str_c('delete_', .$id), 'DELETE', style='margin-top: 32px;')
            )
          )
          ,tags$hr()
        )
      } else {
        tags$div(
          fluidRow(
            column(
              4
              ,tags$h3(.$name)
              ,tags$p(.$category)
            )
            ,column(
              8
              ,tags$p(.$hasit)
              ,actionButton(paste0('unlog_', .$id), 'Unlog')
            )
          )
          ,tags$hr()
        )
      }
    }) %>% `[[`('tag') %>% as.list
    do.call(tagList, equipTags)
  })
  
  output$selectCategory <- renderUI({
    selectInput('newEquipmentCategory', 'Equipment category', state$matos$category$name, width = '100%')
  })
  
})