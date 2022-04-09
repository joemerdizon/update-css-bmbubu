<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addptask.aspx.cs" MasterPageFile="~/MasterNewUI.Master" Inherits="ManageUPPRM.addptask" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReferenceMaterialEditonModal" Src="~/UserControls/ReferenceMaterialEditonModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script src="js/Kendo.all.min.js"></script>
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#datepicker").datepicker({ todayHighlight: true, startDate: new Date() });

            $("form").validationEngine('attach', {
                promptPosition: "topRight", focusFirstField: true,
                onValidationComplete: function (form, status) {
                    if (status) {
                        ShowWorkingModal();
                    }
                    else {
                        CloseWorkingModal();
                    };

                    return status;
                }
            });

            $('.scheduler-repeat').scheduler();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="modals" runat="server">
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer"></uc:YouTubeModalPlayer>
    <uc:ReferenceMaterialEditonModal runat="server"></uc:ReferenceMaterialEditonModal>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">Personal Task
                <small>A task that is personal to the owner, viewable and actionable only by the task owner</small>
            </h3>
            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="tasks.aspx?action=<%=ManageUPPRM.Catalogs.TaskCategory.Personal%>">Personal Tasks</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Create</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ID="TaskID" ClientIDMode="Static" runat="server" />
            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span>New Personal Task</span>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <h3 class="form-section subtask-modal-content">General Information</h3>

                        <div class="row subtask-modal-content margin-bottom-20">
                            <div class="col-md-6">
                                <label class="control-label col-md-3">Name</label>
                                <div class="col-md-9">
                                    <asp:TextBox CssClass="validate[required] taskname form-control" ID="TaskName" runat="server" ClientIDMode="Static"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="control-label col-md-3">Description</label>
                                <div class="col-md-9">
                                    <asp:TextBox ID="TaskDescription" CssClass="taskdescription form-control" runat="server" ClientIDMode="Static"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row margin-top-20 assign-modal-content subtask-modal-content ">
                            <div class="col-md-4">
                                <label class="control-label col-md-5">Due Date</label>
                                <div class="col-md-7">
                                    <input type="text" id="datepicker" runat="server" class="dateC calender form-control" clientidmode="Static" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Head's Up days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="HeadsUp" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label col-md-6">Urgent days</label>
                                <div class="col-md-6">
                                    <asp:TextBox ID="Urgent" CssClass="validate[required] text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:PlaceHolder runat="server" ID="recurrenceContainer">
                            <h3 class="form-section subtask-modal-content">Recurrence</h3>
                            <div class="row">
                                <div class="col-md-9">
                                    <uc:RepeatSchedule ID="RepeatSchedule" runat="server" />
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <h3 class="form-section">Reference Materials</h3>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:PlaceHolder ID="phUserControl" runat="server"></asp:PlaceHolder>
                            </div>
                        </div>

                        <uc:TaskComments ShowAddCommentButton="false" Collapsed="false" runat="server" ID="TaskComments"></uc:TaskComments>

                        <div class="row">
                            <div class="col-md-12">
                                <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Selected="true" Enabled="false">Personal</asp:ListItem>
                                    <asp:ListItem>Add to Transparency Chart</asp:ListItem>
                                    <%--<asp:ListItem>Add to Calendar</asp:ListItem>--%>
                                </asp:CheckBoxList>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="SaveTask" runat="server" Text="Save" OnClick="SaveTask_Click" CssClass="btn green" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" runat="server" id="repeatPatternSetValue" class="repeat-pattern-set-value" />
</asp:Content>
