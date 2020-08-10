pageextension 50038 "Vat Entries Ext" extends "VAT Entries"
{
    layout
    {
        addafter("Bill-to/Pay-to No.")
        {
            field(BillToPayToNameVar; BillToPayToNameVar)
            {
                Caption = 'Bill-To/Pay-To Name';
                ToolTip = '';
                ApplicationArea = All;
            }
            field(BillToPayToCityVar; BillToPayToCityVar)
            {
                Caption = 'Bill-To/Pay-To City';
                ToolTip = '';
                ApplicationArea = All;
            }
            field(TRNNoVar; TRNNoVar)
            {
                Caption = 'TRN No.';
                ToolTip = '';
                ApplicationArea = All;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        Clear(BillToPayToNameVar);
        Clear(BillToPayToCityVar);
        Clear(TRNNoVar);
        if Type = Type::Purchase then
            if VendorG.get("Bill-to/Pay-to No.") then begin
                BillToPayToNameVar := VendorG.Name;
                BillToPayToCityVar := VendorG.City;
                TRNNoVar := VendorG."VAT Registration No.";
            end;
        if Type = Type::Sale then
            if CustomerG.get("Bill-to/Pay-to No.") then begin
                BillToPayToNameVar := CustomerG.Name;
                BillToPayToCityVar := CustomerG.City;
                TRNNoVar := CustomerG."VAT Registration No.";
            end;
    end;

    var
        VendorG: Record Vendor;
        CustomerG: Record Customer;
        BillToPayToNameVar: Text[50];
        TRNNoVar: Code[20];
        BillToPayToCityVar: Text[50];
}