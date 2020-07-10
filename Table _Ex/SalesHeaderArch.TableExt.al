tableextension 50000 "Sales Header Arch" extends "Sales Header Archive"
{
    fields
    {

        modify("Location Code")
        {
            Description = 'Project Location';
        }
        field(50005; "Project Location Name"; TExt[100])
        {
            Caption = 'Project Location Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50006; "kitchen Location"; Code[20])
        {
            Caption = 'kitchen Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50007; "kitchen Location Name"; TExt[100])
        {
            Caption = 'kitchen Location Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; "Project Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50010; "Type of Sale"; Option)
        {
            Caption = 'Type of Event';
            OptionMembers = " ","Events","Contract","Counter Sale","Facility Management","Contract-Event","Others";
            OptionCaption = ' ,Events,Contract,Counter Sale,Facility Management,Contract-Event,Others';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(50011; "Prepared By"; Code[20])
        {
            Caption = 'Prepared By';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(50012; "Method of Receiving Enquiry"; Code[20])
        {
            Caption = 'Method of Receiving Enquiry';
            DataClassification = CustomerContent;
            TableRelation = "Method Of Receiving Enq.";
        }
        field(50013; "Status of event"; Option)
        {
            Caption = 'Status of event';
            OptionMembers = " ","Inquiry","Tentative","Definite","Cancelled","Turn Down";
            OptionCaption = ' ,Inquiry,Tentative,Definite,Cancelled,Turn Down';
            DataClassification = CustomerContent;
        }
        field(50014; "Date of function start"; Date)
        {
            Caption = 'Date of function start';
            DataClassification = CustomerContent;

        }
        field(50015; "Date of function end"; Date)
        {
            Caption = 'Date of function end';
            DataClassification = CustomerContent;
        }
        field(50016; "Start Time"; Text[1000])
        {
            Caption = 'Start Time';
            DataClassification = CustomerContent;
        }
        field(50017; "End Time"; Text[1000])
        {
            Caption = 'End Time';
            DataClassification = CustomerContent;
        }
        field(50018; "Event"; text[100])
        {
            Caption = 'Event';
            DataClassification = CustomerContent;
        }
        field(50019; "Details of the event"; Text[1024])
        {
            Caption = 'Details of the event';
            DataClassification = CustomerContent;
        }
        field(50020; "Type of Event"; Code[20])
        {
            Caption = 'Type of Event';
            DataClassification = CustomerContent;
            TableRelation = "Event Type";
        }
        field(50021; "Segment"; Code[20])
        {
            Caption = 'Segment';
            DataClassification = CustomerContent;
            TableRelation = Segment;
        }
        field(50022; "Venue"; Text[100])
        {
            Caption = 'Venue';
            DataClassification = CustomerContent;
        }

        field(50023; "Location BEO"; Text[100])
        {
            Caption = 'Location BEO';
            DataClassification = CustomerContent;
        }
        field(50024; "Guest Expected"; Text[50])
        {
            Caption = 'Guest Expected';
            DataClassification = CustomerContent;

        }
        field(50025; "Guest Guaranteed"; Text[50])
        {
            Caption = 'Guest Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50026; "No. of PAX"; Integer)
        {
            Caption = 'No. of PAX';
            DataClassification = CustomerContent;
        }
        field(50028; "Average Price Per PAX/F&B"; Decimal)
        {
            Caption = 'Average Price Per PAX/F&B';
            DataClassification = CustomerContent;
        }
        field(50029; "Transport (Amount)"; Decimal)
        {
            Caption = 'Transport (Amount)';
            DataClassification = CustomerContent;
        }

        field(50030; "Staff (Amount)"; Decimal)
        {
            Caption = 'Staff (Amount)';
            DataClassification = CustomerContent;
        }
        field(50031; "Menu Price"; Text[50])
        {
            Caption = 'Menu Price';
            DataClassification = CustomerContent;
        }
        field(50032; Pricing; Text[2000])
        {
            Caption = 'Pricing';
            DataClassification = CustomerContent;
        }
        field(50033; "Billing Instruction"; Text[1000])
        {
            Caption = 'Billing Instruction';
            DataClassification = CustomerContent;
        }
        field(50034; "Service Delivery"; Text[2048])
        {
            Caption = 'Service Delivery';
            DataClassification = CustomerContent;
        }
        field(50035; "Service Style"; Text[2048])
        {
            Caption = 'Service Style';
            DataClassification = CustomerContent;
        }
        field(50036; "HK Lines"; Text[2000])
        {
            Caption = 'HK Lines';
            DataClassification = CustomerContent;
        }

        field(50038; "Food & Beverages Notes"; Text[2048])
        {
            Caption = 'Food & Beverages Notes';
            DataClassification = CustomerContent;
        }
        field(50039; "Kitchen"; Text[2048])
        {
            Caption = 'Kitchen';
            DataClassification = CustomerContent;
        }
        field(50040; "Equipment"; Text[2048])
        {
            Caption = 'Equipment';
            DataClassification = CustomerContent;
        }
        field(50041; "Stewarding"; Text[500])
        {
            Caption = 'Stewarding';
            DataClassification = CustomerContent;
        }
        field(50042; "Restrictions"; Text[1024])
        {
            Caption = 'Restrictions';
            DataClassification = CustomerContent;
        }

        field(50043; "Setup Notes"; Text[1024])
        {
            Caption = 'Setup Notes';
            DataClassification = CustomerContent;
        }
        field(50044; "Staffing"; Text[256])
        {
            Caption = 'Staffing';
            DataClassification = CustomerContent;
        }
        field(50045; "Housekeeping"; Text[2000])
        {
            Caption = 'Housekeeping';
            DataClassification = CustomerContent;
        }
        field(50046; "Transportation"; Text[500])
        {
            Caption = 'Transportation';
            DataClassification = CustomerContent;
        }
        field(50047; "Engineering"; Text[1000])
        {
            Caption = 'Engineering';
            DataClassification = CustomerContent;
        }
        field(50048; "Additional Instructions"; Text[1024])
        {
            Caption = 'Additional Instructions';
            DataClassification = CustomerContent;
        }
        field(50049; "Reffered By"; Text[100])
        {
            Caption = 'Reffered By';
            DataClassification = CustomerContent;
        }
        field(50050; Hygiene; Text[2000])
        {
            Caption = 'Hygiene';
            DataClassification = CustomerContent;
        }
        field(50051; "Food Menu1"; Text[2048])
        {

        }
        field(50052; "Food Menu2"; Text[2048])
        {

        }
        field(50053; "Food Menu3"; Text[2048])
        {

        }
        field(50054; "Beverages1"; Text[2048])
        {
            Caption = 'Beverages1';
            DataClassification = CustomerContent;
        }
        field(50055; "Beverages2"; Text[2048])
        {
            Caption = 'Beverages2';
            DataClassification = CustomerContent;
        }
        field(50056; "Modified Fields"; Text[1000])
        {
            Caption = 'Modified Fields';
            DataClassification = CustomerContent;
        }
        field(50057; "Event Transction Status"; Option)
        {
            OptionMembers = " ","Partial Delivered","Full Delivered","Partial Invoiced","Full Invoiced";
            OptionCaption = ' ,Partial Delivered,Full Delivered,Partial Invoiced,Full Invoiced';
            DataClassification = CustomerContent;
        }
        field(50058; "Enquiry Contact No."; Code[20])
        {
            TableRelation = Contact;
            DataClassification = CustomerContent;

        }
        field(50059; "Enquiry Contact Name"; Text[120])
        {
            Caption = 'Enquiry Contact Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50060; "Invoice Description"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50061; "Contact Type"; Option)
        {
            Caption = 'Contact Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ","Company","Person";
            Editable = false;
        }
        field(50062; "Miscellaneous"; Decimal)
        {
            Caption = 'Miscellaneous';
            DataClassification = CustomerContent;
        }
        field(50063; "Bank Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }//: 
        field(50064; "Banquet Order Status"; Option)
        {
            Caption = 'Banquet Order Status';
            OptionCaption = 'Open,Inprocess,BO Released,BO Cancelled';
            OptionMembers = "Open","Inprocess","BO Released","BO Cancelled";
        }

    }
    var
        SalesHeader: Record "Sales Header";
        JobsG: Record Job;
}