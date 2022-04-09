<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static"  MasterPageFile="~/MasterNewUI.Master" CodeBehind="createreportdoc.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.CreateReportDoc" ValidateRequest="false" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>
<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" type="text/css" href="/assets/global/plugins/jstree/dist/themes/default/style.min.css" />
<%--    <link href="/assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>--%>

    <script src="/assets/global/plugins/jstree/dist/jstree.min.js"></script>
    <script src="/assets/admin/pages/scripts/ui-tree.js"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/createreportdoc.js")%>"></script>
    <script src="<%= Page.ContentLastWrite("/assets/global/plugins/fuelux/js/spinner.min.js")%>"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/fuelUx/scheduler.js")%>"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/keepAuthenticationAlive.js")%>"></script>

    <style>
        
        /* signature information */
        p.signature-acknowledge {
            font-weight: bold;
            font-style: italic;
            margin-bottom: 0px;
        }

        .signature-wrapper {
            padding-top: 18px;
        }

        .signature-wrapper label {
            background-color: #fff;
            padding-right: 8px;
        }
        .signature-line {
            height: 15px;
            border-bottom: 1px solid #949594;
        }
        .report-template-footer {
            overflow:auto;
            margin-bottom: 20px;
            margin-top: 20px;
        }

        .note-editor .signature-container {
            overflow:auto;
            border-width: 1px; 
            border-style: dashed; 
            border-color: gray;
            cursor: not-allowed;
        }

        .note-editor .signature-label {
            cursor: not-allowed;
        }

        .default-section-container li.selected-task {
            line-height: 38px;
            padding-left: 50px;
            margin-left: 0;
            list-style: none;
            border-top: 1px solid #DFDFDF;
            clear: both;
        }
        .not-approved {
            color: orange;
        }
        .jstree-container-ul {
            overflow: hidden;
            max-width: 100%;
        }
        .jstree-container-ul a {
            overflow: hidden;
            width: 94%;
            text-overflow: ellipsis;
        }
        .references-title {
            cursor: pointer;
        }
        .modal-dialog-center {
            margin-top: 25%;
        }
        .modal-title {
            font-weight: bold
        }
        .modal-header {
          min-height: 16.42857143px;
          padding: 15px;
          border-bottom: 1px solid #e5e5e5;
        }
        .modal-header .close {
          margin-top: -2px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="ReportID" runat="server" ClientIDMode="Static" />
    <input type="hidden" id="errorsMsjs" runat="server" />
    <input type="hidden" id="successMsj" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">  
    </asp:ScriptManager> 

    <div class="page-content-wrapper">
        <div class="page-content">

            <div class="row">
                <div id="globalError" style="display: none;" class="alert-error"></div>
                <div id="success-msg" class="alert alert-success" style="display: none;"></div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="portlet box mint-background">
                        <div class="portlet-title">
                            <div class="caption">
                                <span id="PageTitle" runat="server"></span>
                            </div>
                            <div class="tools">
                                <a class="" href="javascript:;" id="add-as-fav">
                                    <i class="fa fa-heart"></i>
                                </a>
                                <asp:CheckBox ID="Favorite" runat="server" CssClass="hidden" />
                            </div>
                            <div class="gray-liner"></div>
                            <div class="row">
                                <div class="col-md-2">
                                    <p class="pull-right report-name">Name of Report</p>
                                </div>

                                <div class="col-md-5">
                                    <div class="top-padding">
                                        <asp:TextBox ID="ReportName" CssClass="form-control" runat="server" AutoPostBack="true"></asp:TextBox>
                                    </div>
                                </div>
                            </div>          
                            
                            <div class="row">
                                <div class="col-md-2">
                                    <p class="pull-right report-name">Status</p>
                                </div>

                                <div class="col-md-5">
                                    <div class="top-padding">
                                        <asp:DropDownList ID="Status" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true">
                                        <asp:ListItem Text="Active" Value="true"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="false"></asp:ListItem>
                                        </asp:DropDownList>
                                        <input type="hidden" name="statusId" id="statusId" />
                                    </div>
                                </div>
                            </div>          
                        </div>
                    </div>
                </div>
            </div>

            <div class="row playbook report-container" id="main-row-with-jstree-and-sections">
                <div class="col-md-4">
                    <div class="portlet box">

                        <div class="portlet-title">
                            <div class="caption">
                                TEMPLATE OBJECTIVES
                            </div>
                            <div class="gray-liner"></div>
                            <div class="row">
                                <div class="col-xs-11">
                                    <div class="input-icon top-padding">
                                        <i class="fa fa-search"></i>
                                        <input name="search" class="form-control" id="template-search" placeholder="Search" type="text" onkeydown="if (event.keyCode == 13) return false;"/>
                                    </div>
                                </div>
                                <div class="col-xs-1" style="padding-left: 0px;">
                                    <a type="button" href="#" onclick="javascript: $('#template-search').val('').trigger('keyup');return false;"><i class="fa fa-remove margin-top-20"></i></a>
                                </div>
                            </div>
                        </div>
                        <div class="portlet-body">
                            <div class="light-liner bottom-padding"></div>
                            <div class="references">
                                <h6 class="references-title no-text-selection">Reference <i class="fa fa-caret-down"></i></h6>
                                <ul class="list-inline references-container" style="display:none">
                                    <li><i class="fa fa-tag"></i>Category</li>
                                    <li><i class="fa fa-tags"></i>Sub-Category</li>
                                    <li><i class="fa fa-bullseye"></i>Template Task</li>
                                    <li><i class="fa fa-arrow-circle-right"></i>Action item</li>
                                    <li><i class="fa fa-bullseye not-approved"></i>Template Task (Not Approved)</li>
                                </ul>
                            </div>
                            <div class="light-liner bottom-padding"></div>
                            <div class="scroller" style="height: 600px">
                                <div id="jstree-container">
                                    <div id="DocItems" class="jstree-content">
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <div class="col-md-8 section-and-task-column">
                    <div class="portlet box">

                        <div class="portlet-title">
                            <div class="caption">
                                TEMPLATE SECTIONS
                            </div>
                            <div align="right">
                                <button type="button" class="btn green" id="publish">Publish</button>
                                <button type="button" class="btn green" id="assign">Simulate Assign</button>
                                <button type="button" class="btn blue" id="approval">Send for Approval</button>
                            </div>

                            <div class="gray-liner"></div>

                            <button type="button" class="btn green" id="add-section">+ Add Section</button>
                            <button type="button" class="btn green" id="customize-footer">Customize Footer</button>
                        </div>

                        <div class="portlet-body">
                            <div class="light-liner"></div>
                            <div id="default-section-container" class="template-section"></div>
                            <div id="accordion-container">
                                <div class="controls controls-row jstree-content template-section" id="accordion-section">
                                    <ul class="sections"></ul>
                                </div>
                            </div>
                            
                            <asp:HiddenField ID="ShowAssessmentActions" runat="server"/>
                            <div class="top-liner" id="assessment-actions">
                                <div class="margin-top-15">
                                    <label class="col-sm-4 control-label">Action resulting from assessment:</label>
                                    <div class="col-sm-8 margin-bottom-15">
                                        <div class="checkbox-list">
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Promotion</label>
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Demotion</label>
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Maintained</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="light-liner"></div>

                            <asp:HiddenField ID="ReportTemplateFooter" runat="server"/>
                            <div id="report-template-footer" class="report-template-footer"></div>

                            <div class="text-right width-100 top-liner">
                                <a href="#" class="btn btn-gray btn-120x" onclick="javascript:window.location.href = './ReportDocuments.aspx'; return false;">Cancel </a>
                                <asp:Button ID="SaveReportButton" runat="server" CssClass="btn green btn-120x" OnClick="SaveReport_Click" OnClientClick="showLoadingScreen();" Disabled="true" Text="Save"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="add-task-report row" style="display: none;">
                <div class="embed-responsive embed-responsive-16by9">
                    <iframe src="" data-src="<%= Page.ContentLastWrite("/dashjs/AdddTask.aspx?contentOnly=")%>" frameborder="0" width="95%" style=""></iframe>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalTitle" aria-hidden="true">
          <div class="modal-dialog modal-dialog-center" role="document">
            <asp:UpdatePanel ID="upModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="modal-content">
                      <div class="modal-header">
                        <h4 class="modal-title">Successful</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                          <span aria-hidden="true">&times;</span>
                        </button>
                      </div>
                      <div class="modal-body">
                        The report was saved successfully. <br />
                        Click "Clone" if you want to create a clone of this report.<br /> 
                        Click "Close" to close

                      </div>
                      <div class="modal-footer width-100">
                         <button type="button" class="btn btn-blue btn-120x" runat="server" onserverclick="CloneReport_Click">Clone</button>
                        <button type="button" class="btn btn-gray btn-120x" data-dismiss="modal">Close</button>
                      </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>          
          </div>
        </div>


    </div>
    <script type="text/x-jquery-tmpl" id="only-default-section">
        <ul>
            <div class="default-section-container">
            </div>
        </ul>
    </script>
    <script type="text/x-jquery-tmpl" id="section-content">
        <li data-sectionid="${SectionID}" id="section-container-${SectionID}" class="section-container">
            <div class="portlet box">

                <div class="portlet-title">
                    <div class="pull-left tools">
                        <a href="javascript:;" class="collapse"></a>
                    </div>
                    <div class="caption margin-top-10">
                        <span class="name-head">${Name}</span>
                        <span class="description-head">{{html Description}}</span>
                    </div>
                    <div class="tools text-right">
                        <%--<a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>--%>
                        <a href="javascript:;" class="fa fa-pencil edit-section"></a>
                        <a href="javascript:;" class="fa fa-minus-circle delete-section"></a>
                    </div>
                </div>
                <div class="portlet-body" id="section-content-${SectionID}">
                    <ul class="report-data">
                    </ul>
                </div>
            </div>

            <input type="hidden" name="sectionTaskSelected_${SectionID}" class="sectionTaskSelected" value="${TemplateTaskList}" />
            <input type="hidden" name="sectionName_${SectionID}" class="name-value" value="${Name}" />
            <input type="hidden" name="sectionDescription_${SectionID}" class="description-value" value="${Description}" />
            <input type="hidden" name="sectionOrder_${SectionID}" class="section-order" value="${Order}" />
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="child-task-section">
        <li class="selected-task" data-id="${id}">${text}
            <a data-taskid="${id}" data-taskname="${text}" data-type="action-item" class="fa fa-minus-circle remove-task pull-right" href="javascript:;"></a>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="selected-task-tmpl">
        <li class="templateTask-${id}">
            <span class="marT10 selected-task" data-id="${id}">${text}</span>
            <a data-taskid="${id}" data-taskname="${text}" data-type="parent-task" class="fa fa-minus-circle remove-task pull-right" href="javascript:;"></a>
            <a data-taskid="${id}" data-taskname="${text}" class="fa fa-pencil edit-task pull-right" href="javascript:;"></a>
            <a href="../viewdtask.aspx?templateTaskID=${id}&contentonly=" data-name="${text}" data-tabid="${id}" class="fa fa-eye open-full-screen-modal pull-right"></a>
            <ul class="childTaskContet">
            </ul>
        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="child-template-task-assignment-tmpl">
        <li data-id="${id}">
            <div class="row">
                <span class="col-md-6">${text}</span>
                <div class="col-md-6 input-icon input-medium margin-top-5 margin-bottom-5 pull-right">
                    <i class="fa fa-calendar input-icon"></i>
                    <input type="text" name="templateTaskDueDate-${id}" class="form-control" />
                </div>
            </div>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="parent-template-task-assignment-tmpl">
        <li class="assignTemplateTask-${id}">
            <div class="row">
                <span class="col-md-6" data-id="${id}">${text}</span>
                <div class="col-md-6 input-icon input-medium margin-top-5 margin-bottom-5 pull-right">
                    <i class="fa fa-calendar input-icon"></i>
                    <input type="text" name="templateTaskDueDate-${id}" class="form-control" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <ul class="childTaskContet">
                    </ul>
                </div>
            </div>
        </li>
    </script>

</asp:Content>
<asp:Content ContentPlaceHolderID="modals" ID="modals" runat="server">

    <div id="add-section-modal" class="modal bs-modal-lg fade" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4>Add Section</h4>
                </div>
                <div class="modal-body">
                    <div class="form form-horizontal" role="form">
                        <div class="form-body">
                            <div class="form-group">
                                <label class="control-label col-md-3" for="name">Name</label>
                                <div class="col-md-9">
                                    <input name="name" type="text" class="reset-input form-control" />
                                </div>
                            </div>
                            <div class="control-group">
                                <div class="form-group">
                                    <label class="control-label col-md-3" for="description">Description</label>
                                    <div class="col-md-9">
                                        <textarea name="description" class="with-summernote form-control" rows="4"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="add-section-save" value="Save" />
                    <a href="#" class="btn red" data-dismiss="modal" onclick="">Cancel</a>
                </div>
            </div>
        </div>
    </div>
    <div id="customize-footer-modal" class="modal bs-modal-lg fade" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4>Customize Footer</h4>
                </div>
                <div class="modal-body">
                    <div class="form form-horizontal" role="form">
                        <div class="form-body">
                            <div class="control-group">
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label><input class="md-check" type="checkbox" id="show-assessment-actions" /> Show Assessment Actions</label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <textarea name="footer-html" class="with-summernote with-signature form-control" rows="4"></textarea>
                                    </div>
                                </div>
                                <button type="button" class="btn green" id="add-to-saved-footers">Add To Saved Footers</button>
                                <button type="button" class="btn green" id="load-saved-footer">Load Saved Footer</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="customize-footer-save" value="Save" />
                    <a href="#" class="btn red" data-dismiss="modal" onclick="">Cancel</a>
                </div>
            </div>
        </div>
    </div>
    <div id="load-saved-footer-modal" class="modal bs-modal-lg fade" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4>Load Saved Footer</h4>
                </div>
                <div class="modal-body">
                    <div class="form form-horizontal" role="form">
                        <div class="form-body">
                            <div class="form-group">
                                <label class="control-label col-md-2" for="nameSavedReportFooters">Saved Footers</label>
                                <div class="col-md-4">
                                    <select class="form-control" id="SavedReportFooters"></select>
                                </div>
                                <div class=" col-md-6">
                                    <button type="button" class="btn green" id="edit-saved-footer">Edit</button>
                                    <button type="button" class="btn red" id="delete-saved-footer">Delete</button>
                                </div>
                            </div>
                            <div class="control-group">
                                <div class="form-group">
                                    <label class="control-label col-md-2" for="footer-html">Footer</label>
                                    <div class="col-md-10">
                                        <textarea name="saved-footer-html" class="with-summernote with-signature form-control" rows="4"></textarea>
                                    </div>
                                    <button type="button" class="btn green col-md-offset-2" id="saved-footer-save-changes" style="display:none">Save Changes</button>
                                    <button type="button" class="btn red" id="saved-footer-cancel-changes" style="display:none">Cancel And Discard Changes</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="saved-footer-load" value="Load" />
                    <input type="button" class="btn red" data-dismiss="modal" id="saved-footer-cancel" value="Cancel" />
                </div>
            </div>
        </div>
    </div>
    <div id="confirm-delete-modal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>The section will be deleted, Continue?</h3>
                </div>
                <div class="modal-footer">
                    <a href="javascript:removeSection();" class="btn green">Yes</a>
                    <a href="javascript:void(0);" class="btn red" data-dismiss="modal">No</a>
                </div>
            </div>
        </div>
    </div>
    <div id="confirm-delete-task-modal" class="modal fade" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>The <span></span>task will be deleted from the section, Continue?</h3>
                </div>
                <div class="modal-footer">
                    <a href="javascript:removeTask();" class="btn green">Yes</a>
                    <a href="javascript:void(0);" class="btn red" data-dismiss="modal">No</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
