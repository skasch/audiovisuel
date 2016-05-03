shinyUI(
  bootstrapPage(
    navbarPage(
      'Audiovisual equipment management',
      tabPanel(
        'Equipment', uiOutput('equipmentList')
      )
      ,tabPanel(
        'Management',
        tabsetPanel(
          tabPanel(
            'Add new equipment', 
            fluidPage(
              fluidRow(
                column(
                  6 
                  ,offset = 3
                  ,style = 'background-color: #eee; padding: 16px;'
                  ,column(
                    12
                    ,textInput('newEquipmentName', 'Equipment name', width = '100%')
                    ,uiOutput('selectCategory')
                    ,numericInput('newEquipmentNumber', 'Equipment number', 1, min = 1, width = '100%')
                    ,actionButton('createNewEquipment', 'Create')
                  )
                )
              ) 
            )
          )
          ,tabPanel(
            'Add new category', 
            fluidPage(
              fluidRow(
                column(
                  6 
                  ,offset = 3
                  ,style = 'background-color: #eee; padding: 16px;'
                  ,column(
                    12
                    ,textInput('newCategoryName', 'Category name', width = '100%')
                    ,actionButton('createNewCategory', 'Create')
                  )
                )
              ) 
            )
          )
        )            
      )
    )
  )
)