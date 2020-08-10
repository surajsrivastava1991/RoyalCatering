page 50018 "Cost Allocation List"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Cost Allocation Header";
    CardPageId = "Cost Allocation Card";
    Caption = 'Cost Allocation List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("From Date"; "From Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Location"; "Bulk Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Location Name"; "Bulk Location Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Bulk Allocation Cost"; "Bulk Allocation Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Created"; "Journal Created")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Voucher No.(Pre)"; "Voucher No.(Pre)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Journal Posted"; "Journal Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Voucher No. (Posted)"; "Voucher No. (Posted)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }

    }


}