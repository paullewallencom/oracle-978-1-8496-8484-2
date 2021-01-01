create or replace
PACKAGE XXHR_ABSENCE_IN_WF_PKG AS 

   gError                  CONSTANT NUMBER        := 1;
   gSuccess                CONSTANT NUMBER        := 0;
   gWorkflowItemType       VARCHAR2(8) := 'XXHRIABS';
   gResponsibility         VARCHAR2(100) := 'UK HRMS Manager';
   
   PROCEDURE parse_and_store_xml ( itemtype    IN              VARCHAR2,
                                   itemkey     IN              VARCHAR2,
                                   actid       IN              NUMBER,
                                   funcmode    IN              VARCHAR2,
                                   resultout   IN OUT NOCOPY   VARCHAR2);

   FUNCTION enqueue_msg ( p_event IN VARCHAR2,
                          p_doc   IN CLOB,
                          p_agent IN VARCHAR2,
                          p_msg_text OUT VARCHAR2) RETURN NUMBER; 
                          
   PROCEDURE validate_employee ( itemtype    IN              VARCHAR2,
                                 itemkey     IN              VARCHAR2,
                                 actid       IN              NUMBER,
                                 funcmode    IN              VARCHAR2,
                                 resultout   IN OUT NOCOPY   VARCHAR2);
								 
   PROCEDURE validate_absence_type ( itemtype    IN              VARCHAR2,
                                     itemkey     IN              VARCHAR2,
                                     actid       IN              NUMBER,
                                     funcmode    IN              VARCHAR2,
                                     resultout   IN OUT NOCOPY   VARCHAR2);

   PROCEDURE validate_absence_dates ( itemtype    IN              VARCHAR2,
                                      itemkey     IN              VARCHAR2,
                                      actid       IN              NUMBER,
                                      funcmode    IN              VARCHAR2,
                                      resultout   IN OUT NOCOPY   VARCHAR2);   

   PROCEDURE create_absence ( itemtype    IN              VARCHAR2,
                              itemkey     IN              VARCHAR2,
                              actid       IN              NUMBER,
                              funcmode    IN              VARCHAR2,
                              resultout   IN OUT NOCOPY   VARCHAR2);									  

END XXHR_ABSENCE_IN_WF_PKG;