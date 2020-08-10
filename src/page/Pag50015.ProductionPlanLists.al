page 50015 "Production Plan Lists"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Production Plan Header";
    CardPageId = "Production Plan Card";
    Caption = 'Production Plan Lists';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Production Plan No."; "Production Plan No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("BEO No."; "BEO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Project No."; "Project No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Kitchen Location"; "Kitchen Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Delivery Date"; "Delivery Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("No. of PAX"; "No. of PAX")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Recipe Cost"; "Recipe Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }


            }
        }

    }


}