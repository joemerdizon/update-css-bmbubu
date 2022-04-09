<%@ Page Title="" Language="C#" MasterPageFile="~/dashjs/kaizen/Kaizen.Master" ClientIDMode="static" AutoEventWireup="true" CodeBehind="Kaizen.aspx.cs" Inherits="ManageUPPRM.dashjs.kaizen.Kaizen1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

       <script src="js/kaizenHome.js"></script>
       <script src="js/kaizenUtils.js"></script>

       <link href="//www.fuelcdn.com/fuelux/3.4.0/css/fuelux.min.css" rel="stylesheet">

        <script src="//www.fuelcdn.com/fuelux/3.4.0/js/fuelux.min.js"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

           
                <script type="text/x-jquery-tmpl" id="section-content">
              	   <div class="row datacontainer-custom">
                      <div class="col-md-12 bulb-custom " >
                      <div class="row">
  							<div class="col-xs-12 col-md-12 fontweight-custom">${title}</div>

                            <div {{if what1 == "" || what1 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">What are we trying to accomplish: ${what1}</div>
                            <div {{if what2 == "" || what2 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">What changes can we make that will result in improvement: ${what2}</div>
                            <div {{if how == "" || how == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">How will we know that a change is an improvement: ${how}</div>

                            <div {{if why1 == "" || why1 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">Why 1: ${why1}</div>
                            <div {{if why2 == "" || why2 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">Why 2: ${why2}</div>
                            <div {{if why3 == "" || why3 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">Why 3: ${why3}</div>
                            <div {{if why4 == "" || why4 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">Why 4: ${why4}</div>
                            <div {{if why5 == "" || why5 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom">Why 5: ${why5}</div>
                            
                            <div {{if filename1 == "" || filename1 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom"><a href="${filename1}" target="_blank">Attach 1</a></div>
                            <div {{if filename2 == "" || filename2 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom"><a href="${filename2}" target="_blank">Attach 2</a></div>
                            <div {{if filename3 == "" || filename3 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom"><a href="${filename3}" target="_blank">Attach 3</a></div>
                            <div {{if filename4 == "" || filename4 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom"><a href="${filename4}" target="_blank">Attach 4</a></div>
                            <div {{if filename5 == "" || filename5 == null }} style="display: none"  {{/if}} class="col-xs-12 col-md-12 fontweight-custom"><a href="${filename5}" target="_blank">Attach 5</a></div>
                            


                            <div class="col-xs-12 col-md-12 fontweight-custom">${description}</div>
                             <div class="col-xs-12 col-md-12">
                                <div class="row comment-container-custom">
                                  <div class="col-md-5 pts-custom" style="cursor: pointer" ><img id="divPoints1_${ID}" onClick="doPoints(${ID},-1);" src="graphics/voteNeg.png" width="18">&nbsp;<img id="divPoints2_${ID}" onClick="doPoints(${ID},1);" src="graphics/vote.png" width="18">&nbsp;<a id="labPoints${ID}">${points}pts</a></div>
                                  <div class="col-md-7" style="float:right;">
                                  <div id="divView${ID}" class="commnet-custom  suggestion-custom" style="cursor: pointer; display: inline" onClick="doView(${ID});" ><a href="javascript:"  class="smalllinks">View suggestions (${subitems})</a></div>
                                  <div id="divHide${ID}" class="commnet-custom  suggestion-custom" style="cursor: pointer; display: none" onClick="doHide(${ID});" ><a href="javascript:"  class="smalllinks">Hide suggestions (${subitems})</a></div>
                                  <div class="commnet-custom addcomment-custom" onClick="doAddComment(${ID});" style="cursor: pointer"><a href="javascript:" onClick="doAddComment(${ID});" class="smalllinks">Add comment</a></div>
                                  <div class="commnet-custom submitby-custom">Submitted by ${username}</div>
                                  </div>
                                </div>
                              </div>
 							</div>
                      </div>
                   </div>
                    <div class="col-md-3"></div>
                    <div class="col-md-12">
                        <div id="ItemsList${ID}"></div>
                    </div>
                      <div class="row white-container row-custom">
                      </div>


                </script>

                <script type="text/x-jquery-tmpl" id="item-body">
              	   <div class="row datacontainer-custom">
                      <div class="col-md-12 {{if level < 2}} {{/if}}" >
                      <div class="row">
  							<div class="col-xs-12 col-md-12 fontweight-custom">${title}</div>
                            <div class="col-xs-12 col-md-12 fontweight-custom">${description}</div>

                              <div class="col-xs-12 col-md-12">
                                <div class="row comment-container-custom">
                                  <div class="col-md-5 pts-custom" style="cursor: pointer" ><img onClick="doPoints(${ID},-1);" src="graphics/voteNeg.png" width="18">&nbsp;<img onClick="doPoints(${ID},1);" src="graphics/vote.png" width="18">&nbsp;<a id="labPoints${ID}">${points}pts</a></div>
                                  <div class="col-md-7" style="float:right;">
                                  <div class="commnet-custom addcomment-custom"><a href="javascript:" onClick="doAddComment(${ID});" class="smalllinks">Add comment</a></div>
                                  <div class="commnet-custom submitby-custom">Submitted by ${username}</div>
                                  </div>
                                </div>
                              </div>
 							</div>
                      </div>
                                                 

                   </div>
                      <div class="row white-container row-custom">
                      </div>


                </script>

                    <script type="text/x-jquery-tmpl" id="leaderboard-content">
                    <div class="row datacontainer-leaderboard">
                        <div class="col-cus-3 leaderboard-right-seperator   "><input type="button" value="${categoryName}" class="button-modal-leaderboard"> </div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[0] != null }} ${scores[0].user.name} <br/>(${scores[0].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[1] != null }} ${scores[1].user.name} <br/>(${scores[1].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[2] != null }} ${scores[2].user.name} <br/>(${scores[2].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[3] != null }} ${scores[3].user.name} <br/>(${scores[3].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[4] != null }} ${scores[4].user.name} <br/>(${scores[4].score}) {{/if}}</div>

                        
                    </div>
                </script>





              <div class="col-md-9">
                  <div id="ItemsList"></div>

                  <div class="row white-container row-custom">
                      <form >
                      </form>
                  </div>
                 
                   
                 
              </div>


        <div id="loading-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header popheader-modal-tabular">
                        <h4 class="modal-title" id="myModalLabel">Working</h4>
                    </div>

                    <br /><br />
                    <div align="center">
                        <img src="/dashjs/js/img/ajax-loader.gif" />
                    </div>
                    <br /><br />
                    <div>
                    </div>
                </div>
            </div>
        </div>

<div class="modal fade fuelux" id="category-modal" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
    <div class="modal-dialog modal-lg" >
        <div class="modal-content">
            <div class="modal-header popheader-modal-tabular">
                <button type="button" class="close close-modal" data-dismiss="modal" aria-hidden="true">X</button>
                <h4 class="modal-title" id="modalNewItemTitle">New Kaizen Item</h4>
            </div>
            <div class="modal-body">
                <div class="row white-container row-custom">

                <input type="hidden" id="txtParentId" runat="server" class="form-control custom-border-leaderboard" >


      <h4 class="modal-title">Your current score for this Kaizen post:</a><a id="labScore">0</a></h4><br />
<div class="wizard" data-initialize="wizard" id="myWizard">
<ul class="steps">
    <li data-step="1" class="active"><span class="badge">1</span>One<span class="chevron"></span></li>
    <li data-step="2"><span class="badge">2</span>Two<span class="chevron"></span></li>
    <li data-step="3"><span class="badge">3</span>Three<span class="chevron"></span></li>
  </ul>
  <div class="actions">
    <button onclick="return false;" class="btn btn-default btn-prev"><span class="glyphicon glyphicon-arrow-left"></span>Prev</button>
    <button onclick="return false;" class="btn btn-default btn-next" data-last="Complete">Next<span class="glyphicon glyphicon-arrow-right"></span></button>
  </div>
  <div class="step-content" style="height:500px; overflow: scroll">
          <div class="step-pane sample-pane bg-danger alert" data-step="1">
      <h4>General</h4>
      <p>

                <div class="control-group" id="groupCategory1">
                    <label class="control-label" for="fname">Primary Category</label>
                    <div class="controls">
                        <asp:DropDownList width="250px" ID="cmbCategory2" DataTextField="name" DataValueField="ID"  runat="server" class="form-control custom-border-leaderboard"></asp:DropDownList>
                    </div>
                    <br />

                </div>
      
                          <div class="control-group" id="groupCategory2">
                    <label class="control-label" for="fname">Secondary Category</label>
                    <div class="controls">
                        <asp:DropDownList width="250px" ID="cmbCategory1" DataTextField="name" DataValueField="ID"   runat="server" class="form-control custom-border-leaderboard"></asp:DropDownList>
                    </div>
                    <br />
                </div>
                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Title</label>
                    <div class="controls">
                        <input id="txtTitle" runat="server" class="form-control custom-border-leaderboard" type="text" onkeyup="calcScore();" >
                    </div>
                </div>
                <br />
                <div class="control-group">
                    <label class="control-label" for="fname">Comments</label>
                    <div class="controls">
                        <textarea id="txtDescription" runat="server" class="form-control" onkeyup="calcScore();" rows="10" ></textarea>
                        <!--<input id="txtDescription" class="form-control custom-border-leaderboard" type="text" length="200p" >-->
                    </div>
                </div>
                <div>
                    <label class="control-label" for="fname">Attachment 1</label>
                    <div class="controls">
                            <asp:FileUpload ID="FileUpload1" runat="server" class="input-large reset-input" />
                    </div>
                </div>
                <div>
                    <label class="control-label" for="fname">Attachment 2</label>
                    <div class="controls">
                            <asp:FileUpload ID="FileUpload2" runat="server" class="input-large reset-input" />
                    </div>
                </div>
                <div>
                    <label class="control-label" for="fname">Attachment 3</label>
                    <div class="controls">
                            <asp:FileUpload ID="FileUpload3" runat="server" class="input-large reset-input" />
                    </div>
                </div>
                <div>
                    <label class="control-label" for="fname">Attachment 4</label>
                    <div class="controls">
                            <asp:FileUpload ID="FileUpload4" runat="server" class="input-large reset-input" />
                    </div>
                </div>
                <div>
                    <label class="control-label" for="fname">Attachment 5</label>
                    <div class="controls">
                            <asp:FileUpload ID="FileUpload5" runat="server" class="input-large reset-input" />
                    </div>
                </div>


               <br />                        
 
    
      </p>
    </div>

    <div class="step-pane active sample-pane alert" data-step="2">


      <h4>What?</h4>
      <p>
          
                      <div class="control-group" id="groupWhat">
                    <label class="control-label" for="fname">What are we trying to accomplish</label>
                    <div class="controls">
                        <textarea id="txtWhat" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupHow">
                    <label class="control-label" for="fname">How will we know that a change is an improvement</label>
                    <div class="controls">
                        <textarea id="txtHow" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupWhat2">
                    <label class="control-label" for="fname">What changes can we make that will result in improvement</label>
                    <div class="controls">
                        <textarea id="txtWhat2" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>

      </p>
    </div>
    <div class="step-pane sample-pane bg-info alert" data-step="3">
      <h4>Why?</h4>
      <p>


                          <div class="control-group" id="groupWhy1">
                    <label class="control-label" for="fname">Why</label>
                    <div class="controls">
                        <textarea id="txtWhy1" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupWhy2">
                    <label class="control-label" for="fname">Why</label>
                    <div class="controls">
                        <textarea id="txtWhy2" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupWhy3">
                    <label class="control-label" for="fname">Why</label>
                    <div class="controls">
                        <textarea id="txtWhy3" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupWhy4">
                    <label class="control-label" for="fname">Why</label>
                    <div class="controls">
                        <textarea id="txtWhy4" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <div class="control-group" id="groupWhy5">
                    <label class="control-label" for="fname">Why</label>
                    <div class="controls">
                        <textarea id="txtWhy5" runat="server" onkeyup="calcScore();" class="form-control" rows="3" ></textarea>
                    </div>
                </div>
                <input type="button" id="button1" runat="server" class="btn btn-warning" value="Save" onclick="saveItem();" />
                <asp:Button ID="butSubmit" OnClick="butSubmit_Click" OnClientClick="butSubmit_Click" style="display: none" runat="server" Text="Button"  />
      </p>
    </div>



  </div>
</div>



                </div>

            </div>

        </div>
    </div>
</div>
















<div class="modal fade" id="answer-modal" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header popheader-modal-tabular">
                <button type="button" class="close close-modal" data-dismiss="modal" aria-hidden="true">X</button>
                <h4 class="modal-title" id="modalNewItemTitle">New Kaizen Item</h4>
            </div>
            <div class="modal-body">
                <div class="row white-container row-custom">
                    <form >

                <input type="hidden" id="txtParentId" class="form-control custom-border-leaderboard" type="text" >



    <div class="step-pane sample-pane bg-danger alert" data-step="3">
      <p>

                <div class="control-group">
                    <label class="control-label" for="fname">Comments</label>
                    <div class="controls">
                        <textarea id="txtAnswer" class="form-control" rows="10" ></textarea>
                        <!--<input id="txtDescription" class="form-control custom-border-leaderboard" type="text" length="200p" >-->
                    </div>
                </div>
               <br />                        <input type="button" id="button2" runat="server" class="btn btn-warning" value="Save" onclick="saveAnswer();" />
 
    
      </p>
    </div>



                    </form>
                </div>

            </div>

        </div>
    </div>
</div>





<div class="modal fade" id="modalLeaderboard" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
    <div class="modal-dialog modal-lg">

        <div class="modal-content">
            <div class="modal-header popheader-modal-tabular">
                <button type="button" class="close close-modal" data-dismiss="modal" aria-hidden="true">X</button>
                <h4 class="modal-title" id="myModalLabel">Leaderboard</h4>
            </div>

            <div class="modal-body">
                <iframe id="iframeLeaderboard" width="850" height="350" style="overflow: hidden" scrolling="no" frameborder="0" ></iframe>
            </div>
        </div>

            
    </div>
</div>

</asp:Content>



