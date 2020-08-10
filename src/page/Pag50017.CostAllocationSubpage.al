page 50017 "Cost Allocation Subpage"
{

    PageType = ListPart;
    SourceTable = "Cost Allocation Line";
    Caption = 'Cost Allocation Subpage';
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Project No."; "Project No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Editable = false;
                }
                field("Recipe Cost"; "Recipe Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Editable = false;
                }
                field("Allocation %"; "Allocation %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Editable = false;
                }
                field("Allocated Amount"; "Allocated Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                    Editable = false;
                }
                field("Allocated Cost Manual"; "Allocated Cost Manual")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }
    }
}