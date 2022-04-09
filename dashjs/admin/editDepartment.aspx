<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" AutoEventWireup="true" CodeBehind="editDepartment.aspx.cs" Inherits="ManageUPPRM.editDepartment" EnableEventValidation="false" EnableViewStateMac="false"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>

    <script src="../../admin/admin.js"></script>
    <script src="../js/common.js"></script>
    <script src="../js/departmentEdit.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
    <script src="../js/bootstrap-timepicker.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <input type="hidden" id="successMsj" runat="server" />

        <div class="page-content-wrapper">
            <div class="page-content">
                <div >
                    <div >
                        <div class="row-fluid">
                            <ul class="breadcrumb">
                                <li><a id="departmentBreadCrumb" runat="server">Departments</a> <span class="divider">/</span></li>
                                <li class="active" runat="server" id="DepartmentName"></li>
                            </ul>
                        </div>
                        <!-- Only required for left/right tabs -->


                        <div class="portlet light bordered" data-team="false">
                            <div class="portlet-title " style="border: none;">
                                <div class="tabbable-line col-md-9">

                                <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                                    <asp:Literal ID="AdminMenu" runat="server" />
                                </ul>
                            </div></div></div>



                        <div class="row-fluid">
                            <div id="success-msg" class="alert alert-success span12" style="display: none;">
                            </div>
                        </div>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab0">
                                <div class="form-horizontal fuelux no-left-margin label-large" role="form" id="edit-deparment-container">

                                    <legend runat="server" id="DepartmentTitle"></legend>
                                    <div class="alert alert-error" style="display: none;">
                                    </div>

                                    <div class="control-group">
                                        <label class="control-label" for="name">Name</label>
                                        <div class="controls">
                                            <input type="text" class="input-large" name="Name" id="Name" runat="server" />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <label class="control-label" for="description">Description</label>
                                        <div class="controls">
                                            <input type="text" class="input-large" name="Description" id="Description" runat="server" />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <label class="control-label" for="startTime">Business Start Time</label>
                                        <div class="controls">
                                            <div class="span2 input-append bootstrap-timepicker">
                                                <input type="text" class="input-small" id="StartTime" runat="server" />
                                                <span class="add-on"><i class="icon-time"></i></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <label class="control-label" for="endTime">Business End Time</label>
                                        <div class="controls">
                                            <div class="span2 input-append bootstrap-timepicker">
                                                <input type="text" class="input-small" id="EndTime" runat="server" />
                                                <span class="add-on"><i class="icon-time"></i></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row-fluid">
                                        <input type="button" class="btn green" id="save-deparment" value="Save" />
                                    </div>
                                </div>

                                <fieldset class="scheduler-border">
                                    <legend>Branches</legend>
                                    <div class="row-fluid">
                                        <div class="span3">
                                            <input class="btn green" type="button" value="+ New Branch" id="create-departmentbranch">
                                        </div>
                                    </div>
                                    <div id="List">
                                        <table id='DepartmentBranchListTable' class='table table-bordered'>
                                            <thead>
                                                <tr>
                                                    <th class='text-center'>Name</th>
                                                    <th class='text-center'>Description</th>
                                                    <th class='text-center'>Addres Line 1</th>
                                                    <th class='text-center'>Addres Line 2</th>
                                                    <th class='text-center'>City</th>
                                                    <th class='text-center'>State</th>
                                                    <th class='text-center'>Zip Code</th>
                                                    <th class='text-center'>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <asp:Literal ID="DepartmentBranchList" runat="server"></asp:Literal>
                                            </tbody>
                                        </table>
                                    </div>
                                </fieldset>
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

        <div id="department-branch-modal"  class="modal fade"  tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h2>New Branch</h2>
            </div>
            <div class="modal-body">
                <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                    <input type="hidden" name="departmentBranchId" id="departmentBranchId" />
                    <div class="alert alert-error" style="display: none;">
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="name">Name</label>
                        <div class="controls">
                            <input id="branchName" type="text" class="input-large reset-input" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="description">Description</label>
                        <div class="controls">
                            <input id="branchDescription" type="text" class="input-large reset-input" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="addressLine1" class="control-label">Address Line 1</label>
                        <div class="controls controls-row">
                            <input type="text" id="branchAddressLine1" class="input-large reset-input" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="addressLine2" class="control-label">Address Line 2</label>
                        <div class="controls controls-row">
                            <input type="text" id="branchAddressLine2" class="input-large reset-input" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="city" class="control-label">City</label>
                        <div class="controls controls-row">
                            <input type="text" id="branchCity" class="input-large reset-input" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="stateId" class="control-label">State</label>
                        <div class="controls controls-row">
                            <asp:DropDownList ID="USState" runat="server" CssClass="input-large reset-input" AppendDataBoundItems="true">
                            </asp:DropDownList>
                            <input type="hidden" class="value-input" id="branchStateId" />
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="zipcode" class="control-label">Zip Code</label>
                        <div class="controls controls-row">
                            <input type="text" id="branchZipcode" class="input-large reset-input" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <input type="button" class="btn green" id="save-department-branch" value="Save" />
                <input type="button" class="btn red" data-dismiss="modal" onclick="resetForm()" value="Cancel">
            </div>
        </div></div>
        </div>
</asp:Content>
