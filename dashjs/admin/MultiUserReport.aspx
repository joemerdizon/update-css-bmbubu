<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" CodeBehind="MultiUserReport.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.MultiUserReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <meta charset="utf-8" />

    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />

    <link href="/assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/assets/global/css/components.css" id="style_components" rel="stylesheet" type="text/css" />
    <link href="/assets/global/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/layout.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/custom.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/document.css" rel="stylesheet" type="text/css" />
    <link id="style_color" href="/assets/admin/layout/css/themes/darkblue.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="/_ima/favicon.ico" />
    <link href="/assets/global/plugins/bootstrap-datepicker/css/datepicker3.css" rel="stylesheet" type="text/css" />
    <link href="/assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <script src="/assets/global/plugins/jquery.min.js" type="text/javascript"></script>
    <script src="/assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="/assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>

    <script src="/assets/global/scripts/metronic.js" type="text/javascript"></script>
    <script src="/assets/admin/layout/scripts/layout.js" type="text/javascript"></script>
    <script type="text/javascript" src="/dashjs/js/common.js"></script>
    <script type="text/javascript">
        $(function () {
            // initiate layout and plugins
            Metronic.init(); // init metronic core components
            Layout.init(); // init current layout
            //QuickSidebar.init(); // init quick sidebar
            //TableAdvanced.init(); // required for this page

            $(".tooltips").tooltip();

            $(".portlet.section-container .progress-bar").on('click', function () {
                var sectionContainer = $(this).data('displaysection');
                $(this).closest('.section-container').find('.' + sectionContainer + '-category-container .expand').trigger('click');
                $(this).closest('.portlet-title').find('> div > a.expand').trigger('click');
            });

            var fullScreenModal = $('#full-screen-modal');

            fullScreenModal.on('hidden.bs.modal', function () {
                location.reload();
            });
        });
    </script>
</head>
<body class="document-page">
    <div class="row">
        <div class="col-md-6">
            <span id="OrganizationName" runat="server" visible="false"></span>
            <img class="margin-top-5" runat="server" id="ReportClientLogo" src="" height="90" />
        </div>

        <div class="col-md-6 text-right">
            <%--<h1>Report for <span id="EmployeeName" runat="server"></span></h1>--%>
        </div>
    </div>
    <div class="row line-spacing">
        <div class="col-sm-6">

            <div class="group-info-wrapper">
                <label>Employees</label>
                <p class="info-name" runat="server" id="Employees"></p>
            </div>
            <div class="clearfix"></div>

            <div class="clearfix"></div>

            
            <%if (reportTemplateAssignmentID.HasValue)
            {%>
                <div class="group-info-wrapper">
                    <label>Assignment Date</label>
                    <p class="info-name" runat="server" id="ReportAssignmentDate"></p>
                </div>
            <% }
            else
            {%>
                <div class="group-info-wrapper">
                    <label>Report Range</label>
                    <p class="info-name" runat="server" id="ReportRange"></p>
                </div>
            <%}%>
        </div>
        <div class="col-sm-6">
            <div class="clearfix"></div>
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Report Name</label>
                <p class="info-name" runat="server" id="ReportName"></p>
            </div>
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Report Date</label>
                <p class="info-name" runat="server" id="ReportDate"></p>
            </div>
        </div>
    </div>

    <div class="row line-spacing">
        <div class="col-md-2">
            <label>OVERALL STATUS</label>
        </div>
        <div class="col-md-4 text-right" runat="server" id="OverallDescription">
        </div>
        <div class="col-md-6">
            <div class='progress'>
                <div class='progress-bar progress-bar-completion' runat="server" id="TotalComplete">
                </div>
                <div class='progress-bar progress-bar-warning progress-bar-completion' runat="server" id="TotalPending">
                </div>
                <div class='progress-bar progress-bar-danger progress-bar-completion' runat="server" id="TotalOverdue">
                </div>
            </div>
        </div>
    </div>

    <asp:Literal runat="server" ID="ReportData"></asp:Literal>

    <!-- start row -->
<%--    <div class="row line-spacing">
        <label class="col-sm-4 control-label">Action resulting from assessment:</label>
        <div class="col-sm-8">
            <div class="checkbox-list">
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" value="option1" />
                    </div>
                    Promotion
                </label>
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" value="option2" />
                    </div>
                    Demotion
                </label>
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" value="option3" />
                    </div>
                    Maintained
                </label>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <p class="signature-acknowledge">Comments</p>
            <div class="signature-line"></div>
        </div>
        <div class="clearfix"></div>
    </div>

    <div class="row margin-top-20">
        <div class="col-md-12">
            <p class="signature-acknowledge">*The site-specific assessment form will be revised annually (at the beginning of the assessment year).</p>
            <p class="signature-acknowledge">Special Procedures will only include items on the current list.</p>
            <p class="signature-acknowledge">It is the employee's responsibility to stay abreast of current requirements.</p>
        </div>
        <div class="clearfix"></div>
    </div>

    <div class="row">
        <!-- start -->
        <div class="col-sm-6">

            <!-- start sig -->
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Employee Signature</label>
            </div>
            <!-- end sig -->

            <!-- start sig -->
            <div class="clearfix"></div>
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Supervisor Signature</label>
            </div>
            <!-- end sig -->

            <!-- start sig -->
            <div class="clearfix"></div>
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Administrative Director Signature</label>
            </div>
            <!-- end sig -->

            <div class="clearfix"></div>

        </div>
        <!-- end -->


        <!-- start -->
        <div class="col-sm-6">

            <!-- start sig -->
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Date</label>
            </div>
            <!-- end sig -->


            <!-- start sig -->
            <div class="clearfix"></div>
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Date</label>
            </div>
            <!-- end sig -->

            <!-- start sig -->
            <div class="clearfix"></div>
            <div class="signature-wrapper">
                <div class="signature-line"></div>
                <label>Date</label>
            </div>
            <!-- end sig -->

            <div class="clearfix"></div>

        </div>
        <!-- end -->

    </div>--%>
    <!-- end row -->

    <div class="row margin-top-20">
        <div class="col-md-12">
            <span class="pull-right ">
                <span style="vertical-align: bottom">Powered By&nbsp</span>
                <img src="/_ima/logo-blue2.png" width="168px" class="margin-top-20" />
            </span>
        </div>
    </div>
    
    <div id="full-screen-modal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body" style="min-height: 100px;">
                    <iframe src="" frameborder="0" width="98%"></iframe>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
