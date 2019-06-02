var mysql = require('mysql');
var ejs = require('ejs');
var bodyParser = require('body-parser');
var port = 3000;
var userid = 0;

module.exports = function(app,fs)
{

  //=============================================================================mysql연결
  var mySqlClient = mysql.createConnection({
    host : "ss.a100.kr",
    port : 3306,
    user : 'jung',
    password : 'junggogo',
    database : 'jungeun',
    multipleStatements: true
  });
  ////===============================================================================

  mySqlClient.connect();

  app.get('/',function(req,res){
    if (req.session.loggedin) {
      fs.readFile("./views/index.ejs","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
            userid = req.session.username;
            var who = '';
            if (parseInt(userid/10000) == 1) {
              who = 'Doctor';
            }
            else {
              who='Nurse';
            }
            res.send(ejs.render(data, {
                admin_id : userid,
                admin_who : who}
            ));
          }//else end
       })
    } else {
        res.render('../views/page-login.html');
    }
  });

  app.get('/index.html',function(req,res){
    if (req.session.loggedin) {
      fs.readFile("./views/index.ejs","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
            userid = req.session.username;
            var who = '';
            if (parseInt(userid/10000) == 1) {
              who = 'Doctor';
            }
            else {
              who='Nurse';
            }
            res.send(ejs.render(data, {
                admin_id : userid,
                admin_who : who}
            ));
          }//else end
       })
     }
     else{
       res.render('../views/page-login.html');
     }
  });

  app.get('/page-login.html',function(req,res){
      res.render('../views/page-login.html');
  });

  app.post('/page-login.html', function(req, res){
    fs.readFile("./views/page-login.html","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            var body = req.body;
            var test_id = parseInt(body.uid);
            var test_ps = body.password;
            var id_sql ='';
            var lgcheck = body.lgout;

            if(parseInt(test_id/10000) == 1){  // doctor
              id_sql = 'SELECT DID from Doctor where DID='+test_id;
              mySqlClient.query(id_sql,function(error, results){
                  if(error){
                      console.log('error : ', error.message);
                  }else{
                        if (results != null) {
                          if(test_ps=='1234'){
                            req.session.loggedin = true;
                    				req.session.username = test_id;
                            fs.readFile("./views/index.ejs","utf8",function(error, data){
                                if(error){
                                  console.log(error);
                                  console.log('readFile Error');
                                }else{
                                  userid = req.session.username;
                                  var who = '';
                                  if (parseInt(userid/10000) == 1) {
                                    who = 'Doctor';
                                  }
                                  else {
                                    who='Nurse';
                                  }
                                  res.send(ejs.render(data, {
                                      admin_id : userid,
                                      admin_who : who}
                                  ));
                                }//else end
                             })
                          }else{
                            res.render("../views/page-login.html");
                          }
                        }else{
                          res.render("../views/page-login.html");
                        }
                      }/// nurese id select else end
              });
            }
            else if(parseInt(test_id/10000) == 2){ // nurse
              id_sql = 'SELECT NID from Nurse where NID='+test_id;
              mySqlClient.query(id_sql,function(error, results){
                  if(error){
                      console.log('error : ', error.message);
                  }else{
                        if (results != null) {
                          if(test_ps=='1234'){
                            req.session.loggedin = true;
                    				req.session.username = test_id;
                            fs.readFile("./views/index.ejs","utf8",function(error, data){
                                if(error){
                                  console.log(error);
                                  console.log('readFile Error');
                                }else{
                                  userid = req.session.username;
                                  var who = '';
                                  if (parseInt(userid/10000) == 1) {
                                    who = 'Doctor';
                                  }
                                  else {
                                    who='Nurse';
                                  }
                                  res.send(ejs.render(data, {
                                      admin_id : userid,
                                      admin_who : who}
                                  ));
                                }//else end
                             })
                          }else{
                            res.render("../views/page-login.html");
                          }
                        }else{
                          res.render("../views/page-login.html");
                        }
                      }/// nurese id select else end
              });
            }
            else{
              res.render("../views/page-login.html");
            }
        }//else end
     })
  });

  app.post('/logout.html', function(req, res){
    fs.readFile("./views/page-login.html","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            var body = req.body;
            var lgcheck = body.lgout;

            req.session.username=0;
            req.session.loggedin = false;
            res.render("../views/page-login.html");

        }//else end
     })
  });
    // doctor-ex add
  app.get('/add-ptstate-dt-ex',function(req,res){
    userid = req.session.username;
    if (parseInt(userid/10000) == 1) {
      res.render('../views/add-ptstate-dt-ex.html');
    }
    else{
      fs.readFile("./views/index.ejs","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
            userid = req.session.username;
            who='Nurse';
            res.send(ejs.render(data, {
                admin_id : userid,
                admin_who : who}
            ));
          }//else
      })
    }
  });

  app.post('/add-ptstate-dt-ex', function(req, res){
    userid = req.session.username;
    if (parseInt(userid/10000) == 1) {
      //who = 'Doctor';
      fs.readFile("./views/add-ptstate-dt-ex.html","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
            var body = req.body;
            userid = req.session.username;
            var s_pid = body.pid;
            var pid_sql = "SELECT PID FROM Patient WHERE PID= "+ s_pid;
            mySqlClient.query(pid_sql,function(error, results){
                if(error){
                    console.log('error1 : ', error.message,s_pid);
                }else{
                  if (results.length > 0) { // pid 존재
                    mySqlClient.query('INSERT INTO Examination (PID,DID,imp,weight,height,Disability,Drug,family,PH,opinion) VALUES (?,?,?,?,?,?,?,?,?,?)',[
                      body.pid, userid, body.impre,body.wei, body.hei, body.Disa, body.Medi,body.fhis, body.phis, body.opin
                    ], function(error, results){
                        if(error){
                            console.log('error2 : ', error.message);
                        }else{
                          res.render('../views/add-ptstate-dt-ex.html');
                        }
                    });

                  }else{// pid 존재하지않음
                    res.render("../views/add-ptstate-dt-ex.html");
                  }
              }
            });

          }//else end
       })
    }
    else {
      //who='Nurse';
    }

  });

  // doctor-jin add
  app.get('/add-ptstate-dt-jin',function(req,res){
      userid = req.session.username;
      if (parseInt(userid/10000) == 1) {
        res.render('../views/add-ptstate-dt-jin.html');
      }
      else{
        fs.readFile("./views/index.ejs","utf8",function(error, data){
            if(error){
              console.log(error);
              console.log('readFile Error');
            }else{
              userid = req.session.username;
              who='Nurse';
              res.send(ejs.render(data, {
                  admin_id : userid,
                  admin_who : who}
              ));
            }//else
        })
      }
  });

  app.post('/add-ptstate-dt-jin', function(req, res){
    if (parseInt(userid/10000) == 1) {
      //who = 'Doctor';
      fs.readFile("./views/add-ptstate-dt-jin.html","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
              var body = req.body;
              userid = req.session.username;
              s_pid = body.pID;
              pid_sql = "SELECT PID FROM Patient WHERE PID="+s_pid
              mySqlClient.query(pid_sql,function(error, results){
                  if(error){
                      console.log('error : ', error.message);
                  }else{
                    if (results != null) { // pid 존재
                      mySqlClient.query('INSERT INTO DocInput (PID,DID,opinion,prescription) VALUES (?,?,?,?)',[
                        body.pID, userid, body.opin, body.pres
                      ], function(error, results){
                          if(error){
                              console.log('error : ', error.message);
                          }else{
                            res.render('../views/add-ptstate-dt-jin.html');
                          }
                      });

                    }else{// pid 존재하지않음
                      res.render("../views/add-ptstate-dt-jin.html");
                    }
                }
              });
          }//else end
       })
    }
    else {
      //who='Nurse';
    }
  });

  // nurse-vital check
  app.get('/add-ptstate-ns',function(req,res){
      userid = req.session.username;
      if (parseInt(userid/10000) == 2) {
        res.render('../views/add-ptstate-ns.html');
      }
      else{
        fs.readFile("./views/index.ejs","utf8",function(error, data){
            if(error){
              console.log(error);
              console.log('readFile Error');
            }else{
              userid = req.session.username;
              who='Doctor';
              res.send(ejs.render(data, {
                  admin_id : userid,
                  admin_who : who}
              ));
            }//else
        })
      }
  });

  app.post('/add-ptstate-ns', function(req, res){
    if (parseInt(userid/10000) == 2) {
      //who = 'Doctor';
      fs.readFile("./views/add-ptstate-ns.html","utf8",function(error, data){
          if(error){
            console.log(error);
            console.log('readFile Error');
          }else{
              var body = req.body;
              userid = req.session.username;
              s_pid = body.pID;
              pid_sql = "SELECT PID FROM Patient WHERE PID="+s_pid
              mySqlClient.query(pid_sql,function(error, results){
                  if(error){
                      console.log('error : ', error.message);
                  }else{
                    if (results != null) { // pid 존재
                      mySqlClient.query('INSERT INTO NurInput (PID,NID,BP,RR,BT,PR,BS,IT,OP,SpO2) VALUES (?,?,?,?,?,?,?,?,?,?)',[
                        body.pID, userid, body.blpre,body.brenum, body.temper, body.pulse, body.blsugar,body.Intake, body.excretion, body.oxy
                      ], function(error, results){
                          if(error){
                              console.log('error : ', error.message);
                          }else{
                            res.render('../views/add-ptstate-ns.html');
                          }
                      });

                    }else{// pid 존재하지않음
                      res.render("../views/add-ptstate-dt-jin.html");
                    }
                }
              });

          }//else end
       })
    }
    else {
      //who='Nurse';
    }
  });

  // doctor list print
  app.get('/dt-list.html', function(req, res){
    fs.readFile("./views/dt-list.ejs","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            //전제 데이타를 조회한 후 결과를 'results' 매개변수에 저장한다.
            mySqlClient.query('select * from Doctor', function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{
                    //조회결과를 'prodList' 변수에 할당한 후 'list.html' 에 전달한다.
                    res.send(ejs.render(data, {
                        prodList : results,
                        length : results.length}
                    ));
                }
            });
        }//else end
     })
  });
  // doctor add
  app.post('/add-dt.html', function(req, res){
    fs.readFile("./views/add-dt.html","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            var body = req.body;
            userid = req.session.username;
            dt_sql = "INSERT INTO Doctor (name,telecom,address,gender,birthDate,qualification,department,PW) VALUES (?,?,?,?,?,?,?,?);";
            var birth = body.year+'-'+body.month+'-'+body.date;
            //전제 데이타를 조회한 후 결과를 'results' 매개변수에 저장한다.
            mySqlClient.query(dt_sql,[
              body.name, body.tele, body.addr, body.sex, birth, body.qual, body.major, '1234'
            ], function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{
                    res.render('../views/add-dt.html');
                }
            });

        }//else end
     })
  });
  // nurse list print
  app.get('/ns-list.html', function(req, res){
    fs.readFile("./views/ns-list.ejs","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            //전제 데이타를 조회한 후 결과를 'results' 매개변수에 저장한다.
            mySqlClient.query('select * from Nurse', function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{
                    //조회결과를 'prodList' 변수에 할당한 후 'list.html' 에 전달한다.
                    res.send(ejs.render(data, {
                        prodList : results,
                        length : results.length}
                    ));
                }
            });
        }//else end
     })
  });
  // nurse add
  app.post('/add-ns.html', function(req, res){
    fs.readFile("./views/add-ns.html","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            var body = req.body;
            userid = req.session.username;
            dt_sql = "INSERT INTO Nurse (name,telecom,address,gender,birthDate,qualification,department,PW) VALUES (?,?,?,?,?,?,?,?);";
            var birth = body.year+'-'+body.month+'-'+body.date;

            mySqlClient.query(dt_sql,[
              body.name, body.tele, body.addr, body.sex, birth, body.qual, body.major, '1234'
            ], function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{
                    res.render('../views/add-ns.html');
                }
            });
        }//else end
     })
  });
  // pt list print
  app.get('/pt-list.html', function(req, res){
    fs.readFile("./views/pt-list.ejs","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            //전제 데이타를 조회한 후 결과를 'results' 매개변수에 저장한다.
            mySqlClient.query('select * from Patient', function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{


                  //조회결과를 'prodList' 변수에 할당한 후 'list.html' 에 전달한다.
                  res.send(ejs.render(data, {
                      prodList : results,
                      length : results.length}
                  ));
                }
            });
        }//else end
     })
  });
  // pt add
  app.post('/add-pt.html', function(req, res){
    fs.readFile("./views/add-pt.html","utf8",function(error, data){
        if(error){
          console.log(error);
          console.log('readFile Error');
        }else{
            var body = req.body;
            userid = req.session.username;
            dt_sql = "INSERT INTO Patient (name,telecom,address,gender,birthDate,generalPractitioner,bloodtype) VALUES (?,?,?,?,?,?,?);";
            var birth = body.year+'-'+body.month+'-'+body.date;

            mySqlClient.query(dt_sql,[
              body.name, body.tele, body.addr, body.sex, birth, body.gendt, body.blood
            ], function(error, results){
                if(error){
                    console.log('error : ', error.message);
                }else{
                    res.render('../views/add-pt.html');
                }
            });

        }//else end
     })
  });

  // patient search result
  app.post('/pt-list.ejs',function(req,res){
    fs.readFile("./views/pt-list.ejs","utf8",function(error, data){
            if(error){
              console.log(error);
              console.log('readFile Error');
            }else{

                  var body = req.body;
                  var se_pid = parseInt(body.ch_pid);
                  var ex_sql ='SELECT DID, Edate, imp, weight, height, Disability, Drug, family, PH from Examination where PID='+ se_pid+";";
                  var doc_sql ='SELECT DID, Ddate, opinion, prescription from DocInput where PID='+ se_pid+";";
                  var ns_sql ='SELECT NID, Ndate, BP, RR, BT, PR, BS, IT, OP, SpO2 from NurInput where PID='+ se_pid+";";
                  var ex_res= new Array();
                  var doc_res=new Array();
                  var ns_res= new Array();

                  mySqlClient.query(ex_sql+doc_sql+ns_sql,function(error, results){
                          if(error){
                              console.log('error : ', error.message);
                          }else{
                                if (results.length > 0) {
                                  // for (var i = 0; i < results.length; i++) {
                                  //   ex_res = results.slice()
                                  //   console.log("in",ex_res[0].imp);
                                  // }
                                  //
                                  fs.readFile("./views/pt-search_res.ejs","utf8",function(error, data){
                                      if(error){
                                        console.log(error);
                                        console.log('readFile Error');
                                      }else{
                                          console.log("pid: ",se_pid,"e_len: ",results[0].length,"d_len: ",results[1].length);
                                          res.send(ejs.render(data, {
                                              pid : se_pid,
                                              exam_res : results[0],
                                              jin_res : results[1],
                                              vital_res : results[2],
                                              e_len: results[0].length,
                                              j_len: results[1].length,
                                              v_len: results[2].length
                                          }
                                        ));
                                      }//else end
                                   })///// pt-search_res readfile end
                                }
                          }
                  });

                  // mySqlClient.query(doc_sql,function(error, results){
                  //         if(error){
                  //             console.log('error : ', error.message);
                  //         }else{
                  //               if (results.length > 0) {
                  //                   for (var i = 0; i < results.length; i++) {
                  //                     doc_res = results.slice()
                  //                   }
                  //               }
                  //         }
                  // });
                  //
                  // mySqlClient.query(ns_sql,function(error, results){
                  //         if(error){
                  //             console.log('error : ', error.message);
                  //         }else{
                  //               if (results.length > 0) {
                  //                   for (var i = 0; i < results.length; i++) {
                  //                     ns_res = results.slice()
                  //                   }
                  //               }
                  //         }
                  // });


              }
        })
  });

}
