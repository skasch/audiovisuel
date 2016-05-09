shinyServer(function(input, output) {
  
  load('data/matos.RData')
  
  state <- reactiveValues()
  state$matos <- matos
  
  for (equipmentId in matos$equipment$id) {
    local({
      eqId <- equipmentId
      # Delete equipment
      observeEvent(
        input[[str_c('delete_', eqId)]]
        ,{
          state$matos$equipment %<>% filter(id != eqId)
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
        
      # Rent equipment
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
      
      # Unlog equipment
      observeEvent(
        input[[str_c('unlog_', eqId)]]
        ,{
          state$matos$equipment$hasit[state$matos$equipment$id == eqId] <- ''
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
    })
  }
  
  for (categoryId in matos$category$id) {
    local({
      catId <- categoryId
      # Delete category
      observeEvent(
        input[[str_c('delcat_', catId)]]
        ,{
          state$matos$category %<>% filter(id != catId)
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
    })
  }
  
  # Update state
  observe({
    matos <- state$matos
    
    for (eqId in state$matos$equipment$id) {
      # Delete equipment
      observeEvent(
        input[[str_c('delete_', eqId)]]
        ,{
          state$matos$equipment %<>% filter(id != eqId)
          print(state$matos)
          matos <- state$matos
          save(matos, file = 'data/matos.RData')
        }
      )
        
      # Rent equipment
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
      
      # Unlog equipment
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
    
    for (catId in state$matos$category$id) {
      # Delete category
      observeEvent(
        input[[str_c('delcat_', catId)]]
        ,{
          state$matos$category %<>% filter(id != catId)
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
              ,tags$h3(str_c(.$name, ' #', .$number))
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
  
  output$categoryList <- renderUI({
    categories <- state$matos$category
    if (is.null(categories) || length(categories) == 0) {
      return(NULL)
    } 
    categoryTags <- categories %>% rowwise %>% do(tag = {
      tags$div(
        fluidRow(
          column(
            8
            ,tags$h3(.$name)
          )
          ,column(
            4  
            ,actionButton(str_c('delcat_', .$id), 'DELETE', style='margin-top: 16px;')
          )
        )
        ,tags$hr()
      )
    }) %>% `[[`('tag') %>% as.list
    do.call(tagList, categoryTags)
  })
  
  output$selectCategory <- renderUI({
    selectInput('newEquipmentCategory', 'Equipment category', state$matos$category$name)
  })
  
})