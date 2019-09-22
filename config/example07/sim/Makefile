.PHONY: com cov clean debug
OUTPUT = simv_fsm_moore           #设置仿真文件名
ALL_DEFINE = +define+DUMP_VPD     #添加宏定义
 
#code coverage command
CM = -cm line+cond+fsm+branch+tgl    #设置覆盖率检测
CM_NAME = -cm_name $(OUTPUT)        #覆盖率名字
CM_DIR = -cm_dir ./$(OUTPUT).vdb
 
#vpd file name
VPD_NAME = +vpdfile+$(OUTPUT).vpd
 
#compile command
VCS = vcs -sverilog +v2k -timescale=1ns/1ns \
        -debug_all                            \
        +notimingcheck                        \
        +nospecify                            \
        +vcs+flush+all                        \
        $(CM)                               \
        $(CM_NAME)                          \
        $(CM_DIR)                           \
        $(ALL_DEFINE)                        \
        $(VPD_NAME)                            \
        -o $(OUTPUT)                        \
        -l compile.log    
 
#simulation command
SIM =./$(OUTPUT) \
        $(CM) $(CM_NAME) $(CM_DIR)  \
        $(VPD_NAME)\
        -l $(OUTPUT).log
 
#start compile
com:
	$(VCS) -f tb_file_list.f
 
#start simulation
sim:
	$(SIM)
 
#Show the coverage
cov:
	dve -covdir *.vdb &
debug:
	dve -vpd $(OUTPUT).vpd &
 
#Start clean
clean:
	rm -rf ./csrc *.daidir ./csrc *.log *.vpd *.vdb simv* *.key *race.out*
 
