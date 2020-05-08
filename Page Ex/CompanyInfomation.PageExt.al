pageextension 50080 "Company infomation" extends "company information"
{
    layout
    {
        addafter("Bank Branch No.")
        {
            field("Bank Address"; "Bank Address")
            {
                ApplicationArea = all;
                ToolTip = 'Main Brnach Bank Address';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}