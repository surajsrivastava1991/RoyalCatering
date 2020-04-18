page 50006 "Porject List"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = Job;
    CardPageId = "Project Card";
    Caption = 'Project Lists';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(" Project No."; "No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';

                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Kitchen Location"; "Kitchen Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}