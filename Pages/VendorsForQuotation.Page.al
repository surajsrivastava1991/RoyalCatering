page 50004 "Vendors for quotation"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vendors For Quotations";
    CardPageId = "Vendors for quotation";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Select from vendor-item"; "Select from vendor-item")
                {
                    ToolTip = 'Table Fields';
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ToolTip = 'Table Fields';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Select from vendor-item" := true;
    end;
}