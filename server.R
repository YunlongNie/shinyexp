
server <- function(input,output) {
userdata <- reactiveValues(index=0,stop=0,true = NULL,time=NULL,start=NULL,endt =NULL,g=NULL)
observeEvent(input$reset, {
  userdata$index = 0
  userdata$stop= 0
  userdata$true = NULL
  userdata$time=NULL
  userdata$start=NULL
  userdata$endt =NULL
  userdata$g=NULL
})



observeEvent(input$start, {
    userdata$stop <- 1
    userdata$index = userdata$index+1
    userdata$start<- as.numeric(Sys.time())
    userdata$true <-c(userdata$true, ifelse(rbinom(1,size=1,p=0.5),'Left',"Right"))
    userdata$time[userdata$index]<- as.numeric(Sys.time())

  })



observeEvent(input$left, {
 if (userdata$stop==1){
   userdata$g = c(userdata$g,"Left")
    userdata$stop <- 0
    userdata$endt[userdata$index]<- as.numeric(Sys.time())
} else {print('Please click the start button to begin!')}
  # print(difftime(Sys.time(),userdata$t,unit="secs"))
 })
observeEvent(input$right, {
  if (userdata$stop==1){
  userdata$g = c(userdata$g,"Right")	
  userdata$stop <- 0
  userdata$endt[userdata$index]<- as.numeric(Sys.time())	
  } else {print('Please click the start button to begin!')}
  
 })

observeEvent(input$showall, {
   if (userdata$stop==0){
  userdata$stop = 2
} else {print('Please click the start button to begin!')}

  # print(table(guess= userdata$g,answer = userdata$true))
  # round(as.numeric(userdata$endt) -as.numeric(userdata$time),2)%>%paste0(.,'secs')%>%cat('\ntime spent history: ',.,'\n')
  # userdata$counter%>%cat('in total times:',.,'\n')
 })

autoInvalidate <- reactiveTimer(500)

output$plot <- renderPlot({

if (userdata$stop==0)
	{
		
		return(NULL)
	}  else {



if ((as.numeric(Sys.time())-userdata$start)*1000/input$speed > input$nmax&userdata$stop==1) 
{
	plot(x=0,y=0,type="n",axes=F, xlab="", ylab="")
	text(x=0,y=0,label=sprintf("Maximum %s points are shown.\n Please make a choice.",input$nmax))
}


if (userdata$stop==1&(as.numeric(Sys.time())-userdata$start)*1000/input$speed <=input$nmax) 
	{
	 autoInvalidate()
	lim = 5*input$sigma
	if (lim<2) lim =2
	plot(x=0,y=0,type="n",xlim=c(-lim,lim),ylim=c(-lim,lim),main=sprintf('%sth trial',userdata$index))
	points(x=-1,y=0,col=7,pch=19,cex=4)
	points(x=1,y=0,col=7,pch=19,cex=4)
	if (userdata$true[length(userdata$true)]=="Left") mt = -1 else mt=1
	pos = c(rnorm(1,mean=mt,sd=input$sigma),rnorm(1,mean=0,sd=input$sigma));
      	points(x=pos[1],y=pos[2],col=2,pch=3,cex=3);
      	

}
if (userdata$stop==2) {
	
	x = ifelse(userdata$true=="Left", -1, 1)
	y  = ifelse(userdata$g=="Left", -1, 1)
	par(mfrow=c(1,2))
	plot(1:length(x),x,type="b",col=2,xlab="trial",ylab="right or left",ylim=c(-1.5,1.5),main=paste0("accuracy: ",round(mean(y==x)*100)))
	points(1:length(y),y,type="b",col=4)
	time_spend = round(as.numeric(userdata$endt) -as.numeric(userdata$time),2)
           	plot(y=time_spend,x=1:length(time_spend),type="b",col=1,xlab="trial",ylab="time spend",main="Time Spend History")
}
}}
)
}
  

