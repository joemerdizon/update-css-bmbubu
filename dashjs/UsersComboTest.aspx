<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUI.Master" CodeBehind="UsersComboTest.aspx.cs" Inherits="ManageUPPRM.dashjs.UsersComboTest" %>

<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            var firstUserSelected = $('#<%=UsersGroup2.ClientID%>');

            firstUserSelected.find('.selected-users').on('change', function () {
                var selectedUsers = getSelectedUsers(firstUserSelected);
                $('#show-values-container span').text(selectedUsers);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="ContentPlaceHolder1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="form-body">
                <div class="row">
                    <div class="col-md-12">
                        <label class="control-label col-md-3">Users Multiple Dropdown Test</label>
                        <div class="col-md-9">
                            <uc:UsersGroup runat="server" ID="UsersGroup" ButtonConfirmName="Save"></uc:UsersGroup>
                        </div>
                    </div>
                </div>
                <div class="row margin-top-15">
                    <div class="col-md-12">
                        <label class="control-label col-md-3">Users Multiple Dropdown With users count description</label>
                        <div class="col-md-9">
                            <uc:UsersGroup runat="server" ID="UsersGroup1" ShowGroupNames="false"></uc:UsersGroup>
                        </div>
                    </div>
                </div>
                <div class="row margin-top-15">
                    <div class="col-md-12">
                        <label class="control-label col-md-3">First user selected</label>
                        <div class="col-md-9">
                            <uc:UsersGroup runat="server" ID="UsersGroup2"></uc:UsersGroup>
                        </div>
                    </div>
                </div>
                <div class="row margin-top-15" id="show-values-container">
                    <div class="col-md-12">
                        <label class="control-label col-md-3">Show selected users for "First user selected"</label>
                        <div class="col-md-9">
                            <span></span>
                        </div>
                    </div>
                </div>
                <div class="row margin-top-15">
                    <div class="col-md-3 text-right">
                        <a href="#testModal" data-toggle="modal" class="btn green">Launch Test Modal</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="modals" ContentPlaceHolderID="modals" runat="server">
    <div id="testModal" class="modal fade" aria-hidden="true">
        <div class="modal-dialog bs-modal-lg">
            <div class="modal-content modal-lg">
                <div class="modal-header">
                    Modal Test
                </div>
                <div class="modal-body">
                    <div class="form-body">
                        <div class="row">
                            <div class="col-md-12">
                                <label class="control-label col-md-3">Users Multiple Dropdown Test</label>
                                <div class="col-md-9">
                                    <uc:UsersGroup runat="server" ID="UsersGroup3"></uc:UsersGroup>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <a class="btn red" data-dismiss="modal" aria-hidden="true">Close</a>
                </div>
            </div>
        </div>
    </div>

    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
</asp:Content>
