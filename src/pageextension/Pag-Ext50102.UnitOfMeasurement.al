pageextension 50102 "Unit Of Measurement" extends "Units of Measure"
{
    layout
    {
        addafter(Description)
        {
            field("Default Item Rounding"; "Default Item Rounding")
            {
                ApplicationArea = all;
                ToolTip = 'Rounding Precision for Items';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}