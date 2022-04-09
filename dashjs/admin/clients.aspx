<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="clients.aspx.cs" Inherits="ManageUPPRM.clients" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>

    <script src="../../admin/admin.js"></script>
    <script src="../js/common.js"></script>
    <script src="../js/clients.js"></script>
    <script src="../js/bootstrap-datepicker.js"></script>
    <script src="../../Scripts/jquery.isloading.js"></script>
    <link href="../../dashjs/css/datepicker.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="successMsj" runat="server" />


    <div class="page-content-wrapper">
        <div class="page-content">

            <!-- start container -->
            <div class="row">
                <div>


                    <div class="portlet light bordered" data-team="false">
                        <div class="portlet-title " style="border: none;">
                            <div class="tabbable-line col-md-9">

                                <ul class="nav nav-tabs" id="AdminTabs">
                                    <asp:Literal ID="AdminMenu" runat="server" />
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="tab-content">
                        <div class="tab-pane active" id="tab0">
                            <div class="row-fluid">
                                <div id="success-msg" class="alert alert-success span12" style="display: none;">
                                </div>
                            </div>
                            <div class="row-fluid">
                                <h3>Client List</h3>
                            </div>
                            <div class="row-fluid">
                                <div class="span12">
                                    <a class="btn green tooltips" id="create-client" href="javascript:;">Create&nbsp;
                                            <i class="fa fa-plus"></i>
                                    </a>


                                </div>
                            </div>
                            <div id="List" class="">
                                <asp:Literal ID="ClientList" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /container -->
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">



    <div id="client-modal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>New Client</h2>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                        <div class="alert alert-error" style="display: none;">
                        </div>

                        <input type="hidden" name="clientId" class="reset-input" />

                        <div class="control-group">
                            <label for="name" class="control-label">Name</label>
                            <div class="controls controls-row">
                                <input type="text" name="name" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="addressLine1" class="control-label">Address Line 1</label>
                            <div class="controls controls-row">
                                <input type="text" name="addressLine1" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="addressLine2" class="control-label">Address Line 2</label>
                            <div class="controls controls-row">
                                <input type="text" name="addressLine2" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="city" class="control-label">City</label>
                            <div class="controls controls-row">
                                <input type="text" name="city" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="stateId" class="control-label">State</label>
                            <div class="controls controls-row">
                                <asp:DropDownList ID="USState" runat="server" CssClass="input-large reset-input" AppendDataBoundItems="true">
                                </asp:DropDownList>
                            </div>
                            <input type="hidden" name="stateId" id="stateId" />
                        </div>

                        <div class="control-group">
                            <label for="zipcode" class="control-label">Zip Code</label>
                            <div class="controls controls-row">
                                <input type="text" name="zipcode" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="name" class="control-label">Client Title</label>
                            <div class="controls controls-row">
                                <input type="text" name="clientTitle" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="name" class="control-label">Client Branding</label>
                            <div class="controls controls-row">
                                <input type="text" name="clientBranding" class="input-large reset-input" />
                            </div>
                        </div>

                        <div class="control-group" id="startdate-container">
                            <label class="control-label">Start date</label>
                            <div class="controls controls-row">
                                <div class="input-append span2 no-left-margin">
                                    <input type="text" name="startDate" class="with-datepicker form-control input-small reset-input" value="" />
                                    <button type="button" class="btn show-calendar"><i class="icon-calendar"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="control-group">
                            <label class="control-label">End date</label>
                            <div class="controls controls-row">
                                <div class="input-append span2 no-left-margin">
                                    <input type="text" name="endDate" class="with-datepicker form-control input-small reset-input" value="" />
                                    <button type="button" class="btn show-calendar"><i class="icon-calendar"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="control-group">
                            <label for="name" class="control-label">Total Licenses</label>
                            <div class="controls controls-row">
                                <input type="text" name="totalLicenses" class="input-large reset-input" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="save-client" value="Save" />
                    <input type="button" class="btn red" data-dismiss="modal" onclick="resetForm()" value="Cancel" />
                </div>
            </div>
        </div>
    </div>

    <div id="new-admin-user" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Do you want to create a user admin for this client?</h2>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="clientId" id="clientId" />
                </div>


                <div class="modal-footer">
                    <input type="button" class="btn btn-success" id="create-new-client-admin" value="Yes" />
                    <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="doPostBack()">No</a>
                </div>
            </div>
        </div>
    </div>

    <div id="GenericMessage" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body">
            <h3 id="GenericMessageHeader"></h3>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
        </div>
    </div>

</asp:Content>
