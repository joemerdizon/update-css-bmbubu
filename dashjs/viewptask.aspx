<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewptask.aspx.cs" MasterPageFile="~/MasterNewUI.Master" Inherits="ManageUPPRM.viewptask" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="ViewReferences" Src="~/UserControls/ViewReferences.ascx" %>
<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="NewLabel" Src="~/UserControls/NewLabel.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>
<%@ Register TagPrefix="uc" TagName="RelatedTasks" Src="~/UserControls/RelatedTasks.ascx" %>
<%@ Register TagPrefix="uc" TagName="CancelAssignmentModal" Src="~/UserControls/CancelAssignmentModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReactionCreator" Src="~/UserControls/ReactionCreator.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            ShowResourceList();
            ShowAttachmentList();
            $('#liTasks ul li a[data-selected="<%=ManageUPPRM.Catalogs.TaskCategory.Personal %>"]').parent().addClass('active');
            useDashInstedOfEmptyContent();
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">Personal Task
                <small>A Task that is personal to the owner, view and actionable only by task owner</small>
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
                        <a href="#">Details</a>
                    </li>
                </ul>
            </div>

            <asp:HiddenField ClientIDMode="static" ID="TaskID" runat="server" />
            <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-bullseye"></i>
                        <span>Personal Task</span>
                    </div>
                    <div class="actions">
                        <uc:NewLabel runat="server" ID="NewLabel" Visible="false"></uc:NewLabel>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <h3 class="form-section">General Information</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Name:</label>
                                    <div class="col-md-9">
                                        <p id="TaskName" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Description:</label>
                                    <div class="col-md-9">
                                        <p id="TaskDescription" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Due Date:</label>
                                    <div class="col-md-9">
                                        <p id="datepicker" runat="server" class="form-control-static"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <uc:RelatedTasks runat="server" id="RelatedTasks"></uc:RelatedTasks>
                        <uc:ViewReferences runat="server" ID="ViewReferences"></uc:ViewReferences>
                        <uc:TaskComments runat="server" ID="TaskComments"></uc:TaskComments>
                         <div class="row">
                            <asp:CheckBoxList ID="TaskOptions" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Enabled="false">Personal</asp:ListItem>
                                <asp:ListItem Enabled="false">Add to Transparency Chart</asp:ListItem>
                                <%--<asp:ListItem Enabled="false">Add to Calendar</asp:ListItem>--%>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="UpdateTask" runat="server" Text="Edit" OnClick="EditTask_Click" CssClass="btn green" />
                        <asp:Button ID="CompleteTask" runat="server" Text="Complete" OnClick="CompleteTask_Click" CssClass="btn green" />
                        <asp:Button ID="CancelObjective" runat="server" Visible="false" Text="Cancel Assignment" OnClientClick="javascript:$('#CancelAssignmentModal').modal('show'); return false;" CssClass="btn red" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdfPath" runat="server" />
    <asp:HiddenField ID="hdfFileName" runat="server" />

    <asp:HiddenField ID="hdfproviderAccountID" runat="server" />
    <input type="hidden" runat="server" id="repeatPatternSetValue" class="repeat-pattern-set-value" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:CancelAssignmentModal ID="CancelAssignmentModal" runat="server"></uc:CancelAssignmentModal>
    <uc:YouTubeModalPlayer runat="server" ID="YouTubeModalPlayer"></uc:YouTubeModalPlayer>
    <uc:ReactionCreator runat="server"></uc:ReactionCreator>
</asp:Content>
