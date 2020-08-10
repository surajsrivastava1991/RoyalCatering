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
                    trigger OnValidate()
                    begin
                        if PurIndLineG.Get("Document No.", "Line No.") then
                            if PurIndLineG.Type = PurIndLineG.Type::"Fixed Asset" then
                                Error('You cannot select vendor from vendor-item list');
                    end;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ToolTip = 'Table Fields';
                    ApplicationArea = All;
                }
                field("Quote Doc. No."; "Quote Doc. No.")
                {
                    ToolTip = 'Table Fields';
                    ApplicationArea = All;
                }
                field("Quote Line No."; "Quote Line No.")
                {
                    ToolTip = 'Table Fields';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if PurIndLineG.Get("Document No.", "Line No.") then begin
            if PurIndLineG.Type = PurIndLineG.Type::"Fixed Asset" then
                "Select from vendor-item" := false;
        end else
            "Select from vendor-item" := true;
    end;

    var
        PurIndLineG: Record "Purchase Indent Line";
}