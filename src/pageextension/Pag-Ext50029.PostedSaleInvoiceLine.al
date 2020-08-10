pageextension 50029 "Posted Sale Invoice Line" extends "Posted Sales Invoice Subform"
{

    layout
    {
        addafter("Unit Price")
        {
            field(Days; Days)
            {
                ApplicationArea = All;
                ToolTip = 'no of days for facility Management';
            }
            field("Monthly Charges"; "Monthly Charges")
            {
                ApplicationArea = All;
                ToolTip = 'Monthly Charges for Facility Management';
            }
            field("Manday Unit Price"; "Manday Unit Price")
            {
                ApplicationArea = All;
                ToolTip = 'Manday Unit Price For Facility Management';
            }
        }
    }
    actions
    {
    }
}
