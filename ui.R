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
                    ,textInput('newEquipmentName', 'Equipment name')
                    ,uiOutput('selectCategory')
                    ,numericInput('newEquipmentNumber', 'Equipment number', 1, min = 1)
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
                    ,textInput('newCategoryName', 'Category name')
                    ,actionButton('createNewCategory', 'Create')
                  )
                )
              ) 
            )
          )
          ,tabPanel(
            'Manage categories', 
            fluidPage(
              fluidRow(
                column(
                  6 
                  ,offset = 3
                  ,style = 'background-color: #eee; padding: 16px;'
                  ,column(
                    12
                    ,uiOutput('categoryList')
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