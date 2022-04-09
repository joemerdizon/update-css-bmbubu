<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="departments.aspx.cs" Inherits="ManageUPPRM.departments" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>

    <script src="../../admin/admin.js"></script>
    <script src="../js/common.js"></script>
    <script src="../js/departments.js"></script>
    <script src="../js/bootstrap-datepicker.js"></script>
    <script src="../js/bootstrap-timepicker.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <input type="hidden" id="selectedClient" runat="server" />
        <input type="hidden" id="successMsj" runat="server" />


        <div class="page-content-wrapper">
            <div class="page-content">
                <div>
                    <div>
                        <!-- Only required for left/right tabs -->
                                                                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title " style="border: none;">

                        <div class="tabbable-line col-md-9">
                        <ul class="nav nav-tabs home-tabs nav-justified task-widget"  id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                            </div></div></div>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab0">
                                <div class="row-fluid">
                                    <div id="success-msg" class="alert alert-success span12" style="display: none;">
                                    </div>
                                </div>
                                <div class="row-fluid">
                                    <h3>Department List</h3>
                                </div>
                                <div class="row-fluid">
                                    <div class="span3" id="clients-container">
                                        <asp:DropDownList ID="ClientList" runat="server" CssClass="input-xlarge" AppendDataBoundItems="true">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="span3">
                                        <a class="btn green tooltips" id="create-department" href="javascript:;">Create&nbsp;
                                            <i class="fa fa-plus"></i>
                                        </a>

                                    </div>
                                </div>
                                <div id="List">
                                    <asp:Literal ID="DepartmentList" runat="server"></asp:Literal>
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

        <div id="department-modal" class="modal fade"  tabindex="-1" aria-hidden="true" >

            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h2>New Department</h2>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                            <input type="hidden" name="clientId" id="clientId" />
                            <div class="alert alert-error" style="display: none;">
                            </div>

                            <div class="control-group">
                                <label class="control-label" for="name">Name</label>
                                <div class="controls">
                                    <input name="name" type="text" class="input-large reset-input" />
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label" for="description">Description</label>
                                <div class="controls">
                                    <input name="description" type="text" class="input-large reset-input" />
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label" for="startTime">Business Start Time</label>
                                <div class="controls">
                                    <div class="span2 input-append bootstrap-timepicker">
                                        <input type="text" name="startTime" class="input-small reset-input" />
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label" for="endTime">Business End Time</label>
                                <div class="controls">
                                    <div class="span2 input-append bootstrap-timepicker">
                                        <input type="text" name="endTime" class="input-small reset-input" />
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>

                            <fieldset class="scheduler-border">
                                <legend>Branch</legend>

                                <div class="control-group">
                                    <label class="control-label" for="branchname">Name</label>
                                    <div class="controls">
                                        <input name="branchname" type="text" class="input-large reset-input" />
                                    </div>
                                </div>

                                <div class="control-group">
                                    <label class="control-label" for="branchdescription">Description</label>
                                    <div class="controls">
                                        <input name="branchdescription" type="text" class="input-large reset-input" />
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
                                        <input type="hidden" class="value-input" name="stateId" id="stateId" />
                                    </div>
                                </div>

                                <div class="control-group">
                                    <label for="zipcode" class="control-label">Zip Code</label>
                                    <div class="controls controls-row">
                                        <input type="text" name="zipcode" class="input-large reset-input" />
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-success" id="save-department" value="Save" />
                        <a href="#" class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                    </div>
                </div>
            </div>
        </div>

</asp:Content>
