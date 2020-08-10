pageextension 50005 "Project Card" extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Ending Date")
        {
            field("Kitchen Location"; "Kitchen Location")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
            field("Kitchen Location Name"; "Kitchen Location Name")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}