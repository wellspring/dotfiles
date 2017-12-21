require 'rubygems'                       # Load rubygems (only needed in 1.8)
require 'irb/completion'                 # Enable completion with TAB key
require 'base64'                         # Because i use it often :p
require 'json'                           # Because i use it often :p
require 'yaml'                           # Because i use it often :p
require 'csv'                            # Because i use it often :p
require 'openssl'                        # Because i use it often :p

# Enable colorization
begin
  require 'wirble'                       # Wirble enables to color output like pry
  Wirble.init
  Wirble.colorize
rescue LoadError
end

# Enable hIRB enhanced features
begin
  require 'hirb'                         # Various enhancements for irb
  Hirb::View.enable
rescue LoadError
end

# Enable activesupport niceties even outside Rails (e.g. `3.years.ago`)
begin
  require 'active_support/all'
rescue LoadError
end

# REVERSE ENGINEERING -- Enable radare2 support if enabled
if ENV.include? 'R2PIPE_IN'
  begin
    require 'r2pipe'
    $r = R2Pipe.new
  rescue LoadError
    puts 'WARNING: Could not load r2pipe. (please do `gem install r2pipe`)'
  end

  def back; exit; end
  def r2_eval(cmd); $r.cmd(cmd.to_s).chomp; end
  def r2(cmd=nil); cmd ? JSON(r2_eval(cmd)).to_struct : exit; end
  def r2_dkvp(cmd); r2_eval(cmd).split("\n").map {|line| Hash[line.scan(/(\S+?)=([^\s,;]+)/)].to_struct }; end
  def r2_nidx(cmd,*fields); r2_eval(cmd).split("\n").map {|line| Hash[fields.zip(line.split(/[\t ]/))].to_struct  }; end
  def goto(addr); r2_eval "s #{addr}";addr; end # alias `cd`
  def goto_undo; r2_eval 's-'; end
  def goto_redo; r2_eval 's+'; end
  def goto_beginoffunction; r2_eval 'sf.'; end
  def goto_beginofsection; r2_eval 'sg'; end
  def goto_endofsection; r2_eval 'sG'; end
  def analyze; r2_eval 'aaaa'; nil; end
  def config; r2 'ej'; end
  def theme; r2 'ecj'; end
  def syscalls; r2 'asj'; end
  def history; r2_eval('!').scan(/(.*?)\s*# !\d+$/).flatten; end

  def file; r2 'ij' ; end
  def entrypoints; r2 'iej'; end
  def main; r2 'iMj'; end
  def sections; r2 'iSj'; end
  def exports; r2 'iEj'; end
  def imports; r2 'iij'; end
  def relocations; r2 'irj'; end
  def resources; r2 'iRj'; end
  def librairies; r2 'ilj'; end
  def symbols; r2 'isj'; end
  def strings; r2 'izj'; end
  def functions; r2 'aflj'; end
  def local_variables(addr); r2 "afvj @ #{addr}"; end

  def rename_function(name, addr=nil); r2_eval "afn #{name}#{" @ #{addr}" if addr}"; end
  def remove_comment(addr, txt); r2_eval "CCu #{txt} @ #{addr}"; end
  def unique_comment(addr, txt); r2_eval "CCu #{txt} @ #{addr}"; end
  def comment(addr, txt=nil); r2_eval txt ? "CCa #{addr} #{txt}" : "CC. @ #{addr}"; end
  def label(addr, name=nil); r2_eval name ? "f me.#{name} @ #{addr}" : "fij 1 @ #{addr}"; end
  def local_label(addr,name=nil); r2_eval name ? "f. me.#{name} @ #{addr}" : "fij 1 @ #{addr}"; end
  def label_n(addr,prefix); r2_eval "fe #{prefix} @ #{addr}"; end
  def reset_label_counter; r2_eval 'fe-'; end
  def rename_label(oldname,newname); r2_eval "fr #{oldname} #{newname}"; end
  def remove_label(addr); r2_eval "f- @ #{addr}"; end
  def labels_groups; r2 'fsj'; end

# | dbc <addr> <cmd>         Run command when breakpoint is hit
# | dbC <addr> <cmd>         Set breakpoint condition on command
# | dbf                      Put a breakpoint into every no-return function
# | dbte <addr>              Enable Breakpoint Trace
# | dbtd <addr>              Disable Breakpoint Trace
# | dbts <addr>              Swap Breakpoint Trace
# | dbm <module> <offset>    Add a breakpoint at an offset from a module's base
# | dbn [<name>]             Show or set name for current breakpoint
# | dbic <index> <cmd>       Run command at breakpoint index
# | dbie <index>             Enable breakpoint by index
# | dbid <index>             Disable breakpoint by index
# | dbis <index>             Swap Nth breakpoint
# | dbite <index>            Enable breakpoint Trace by index
# | dbitd <index>            Disable breakpoint Trace by index
# | dbits <index>            Swap Nth breakpoint trace
# | dbh x86                  Set/list breakpoint plugin handlers
# | dbh- <name>              Remove breakpoint plugin handler
# | dbw <addr> <rw>          Add watchpoint
# | drx number addr len rwx  Modify hardware breakpoint
# | drx-number               Clear hardware breakpoint

  #Here's a list of some quick checks to retrieve information from an esil string. Relevant information will be probably found in the first expression of the list.
# indexOf('[')       ->    have memory references
# indexOf("=[")      ->    write in memory
# indexOf("pc,=")    ->    modifies program counter (branch, jump, call)
# indexOf("sp,=")    ->    modifies the stack (what if we found sp+= or sp-=?)
# indexOf("=")       ->    retrieve src and dst
# indexOf(":")       ->    unknown esil, raw opcode ahead
# indexOf("%")       ->    accesses internal esil vm flags
# indexOf("$")       ->    syscall
# indexOf("$$")      ->    can trap
# indexOf('++')      ->    has iterator
# indexOf('--')      ->    count to zero
# indexOf("?{")      ->    conditional
# indexOf("LOOP")    ->    is a loop (rep?)
# equalsTo("")       ->    empty string, means: nop (wrong, if we append pc+=x)


  def breakpoint(addr); r2_eval "db #{addr}"; end # alias `bp`
  def breakpoint_enable(addr); r2_eval "dbe #{addr}"; end # alias `bpe`
  def breakpoint_disable(addr); r2_eval "dbd #{addr}"; end # alias `bpd`
  def breakpoint_toggle(addr); r2_eval "dbs #{addr}"; end
  def breakpoints; r2 'dbj'; end # alias `bpl`
  def backtrace; r2 'dbtj'; end # alias `bt`
  def memmaps; r2 'dmj'; end # alias `mm`
  def modules; r2 'dmmj'; end # alias `m`
  def threads; r2 '&j'; end # alias `t`
  def registers; r2 'drj'; end # alias `reg`
  def registers_refs; r2_eval 'drr'; end
  def registers_changes; r2_eval 'drd'; end #alias `register-diff`
  def signalhandlers; r2 'dkj'; end
  def filedescriptors; r2 'ddj'; end
  def logs; r2 'Tj'; end
  def log(txt); r2_eval "T #{txt}"; end
  def debug(args); r2_eval "doo #{args}"; end
  def detach; r2_eval "o-"; end
  def send_signal(n,pid); r2_eval "dck #{n} #{pid}"; end
  def switchto_thread(id); r2_eval "dpt=#{id}"; end
  def stop; r2_eval; 'dk'; end
  def continue; r2_eval; 'dc'; end # alias `c`
  def continue_until(addr,addr2=nil); r2_eval; "dcu #{[addr,addr2].compact.join(' ')}"; end
  def continue_until_ret; r2_eval; 'dcr'; end
  def continue_until_call; r2_eval; 'dcc'; end
  def continue_until_callreg; r2_eval; 'dccu'; end
  def continue_until_syscall; r2_eval; 'dcs'; end
  def continue_until_fork; r2_eval; 'dcf'; end
  def continue_until_programcode; r2_eval; 'dcp'; end
  def skip(n=1); r2_eval; "dss #{n}"; end
  def step_into(n=1); r2_eval; "ds #{n}"; end
  def step_over(n=1); r2_eval; "dso #{n}"; end
  def step_back; r2_eval; 'dsb'; end

#  | dr?<register>         Show value of given register
#  | dr <register>=<val>   Set register value

#  | dsp              Step into program (skip libs)
#  | dsi <cond>       Continue until condition matches
#  | dsf              Step until end of frame
#  | dsu[?]<address>  Step until address
#  | dsui[r] <instr>  Step until an instruction that matches `instr`, use dsuir for regex match
#  | dsue <esil>      Step until esil expression matches
#  | dsuf <flag>      Step until pc == flag matching name

#| dx[?]                   Inject and run code on target process (See gs)

#| dmsj                List snapshots in JSON

#|Usage: dmp Change page permissions
#| dmp [addr] [size] [perms]  Change permissions
#| dmp [perms]                Change dbg.map permissions
  #
  #|Usage: dt Trace commands
# | dt                                 List all traces
# | dt [addr]                          Show trace info at address
# | dt%                                TODO
# | dt*                                List all traced opcode offsets
# | dt+ [addr] [times]                 Add trace for address N times
# | dt-                                Reset traces (instruction/calls)
# | dtD                                Show dwarf trace (at*|rsc dwarf-traces $FILE)
# | dta 0x804020 ...                   Only trace given addresses
# | dtc[?][addr]|([from] [to] [addr])  Trace call/ret
# | dtd                                List all traced disassembled
# | dte[?]                             Show esil trace logs
# | dtg                                Graph call/ret trace
# | dtg*                               Graph in agn/age commands. use .dtg*;aggi for visual
# | dtgi                               Interactive debug trace
# | dtr                                Show traces as range commands (ar+)
# | dts[?]                             Trace sessions
# | dtt [tag]                          Select trace tag (no arg unsets)


# |Usage: dm # Memory maps commands
# | dm                               List memory maps of target process
# | dm address size                  Allocate <size> bytes at <address> (anywhere if address is -1) in child process
# | dm=                              List memory maps of target process (ascii-art bars)
# | dm.                              Show map name of current address
# | dm*                              List memmaps in radare commands
# | dm- address                      Deallocate memory map of <address>
# | dmd[a] [file]                    Dump current (all) debug map region to a file (from-to.dmp) (see Sd)
# dmda -> dump all memory sections files
# | dmh[?]                           Show map of heap
# | dmi [addr|libname] [symname]     List symbols of target lib
# | dmi* [addr|libname] [symname]    List symbols of target lib in radare commands
# | dmi.                             List closest symbol to the current address
# | dmiv                             Show address of given symbol for given lib
# | dmj                              List memmaps in JSON format
# | dml <file>                       Load contents of file into the current map region (see Sl)
# | dmm[?][j*]                       List modules (libraries, binaries loaded in memory)
# | dmp[?] <address> <size> <perms>  Change page at <address> with <size>, protection <perms> (rwx)
# | dms[?] <id> <mapaddr>            Take memory snapshot
# | dms- <id> <mapaddr>              Restore memory snapshot
# | dmS [addr|libname] [sectname]    List sections of target lib
# | dmS* [addr|libname] [sectname]   List sections of target lib in radare commands




  def section(name); sections.select {|s| s.name[/#{name}/] }.first; end
  def find_references(addr='$$'); r2_eval("/r #{addr}").gsub(/\x1b\[[0-9;]*m/, '').scan(/^(\S+)\s+(0x\S+)\s+(.*) in (.*)$/).map {|e| [:type, :addr, :instruction, :function].zip(e).to_h.to_struct }; end
  def find_instruction(asm); r2 "\"/cj #{asm}\""; end
  def find_string(str, i=true); r2 "/#{'i' if i}j #{str}"; end
  def find_regex(regex, flags=''); r2 "/ej /#{regex}/#{flags}"; end
  def find_bytes(bytes); r2 "/xj #{bytes}"; end
  def find_again; r2 '//'; end
  def find_next(instructiontype,from='$$'); instruction(r2_nidx("s/A #{instructiontype} @ #{from} ~:0", :addr,:size,:opstr)[0].addr); end   # e.g. find_next(:cjmp, 0x006d8f61)
  #find_backwards: r2_eval("/c lea @e:search.from=0x4d6e74-0x500,search.to=0x4d6e74 ~[0]").split.reverse.map{|addr| d=r2_eval("pd 1 @ #{addr} ~str"); break d if(!d.empty?) }
  #find_backwards: r2_eval("pd -500 @ 0x4d6e74 #@e:scr.color=false").scan(/.*str.*/).last

  def basicblocks(addr='$$'); r2 "afbj @ #{addr}"; end
  def disassemble_hex(hex); r2 "abj #{hex}"; end
  def assemble(asm); r2_eval "\"pa #{asm}\""; end
  def previous_instruction(addr='$$'); instructions(addr, -1)[0] rescue nil; end
  def instruction(addr='$$'); instructions(addr)[0] rescue nil; end
  def instructions(addr='$$',n=1); r2("pij #{n} @ #{addr}") rescue []; end
  def str(addr='$$'); r2_eval "psz @ #{addr}"; end
  def bytes(addr='$$',size=1); r2 "p8j #{size} @ #{addr}"; end # alias `read`                                        # ( byte:  8 bits)
  def words(addr='$$',size=1); r2("pxhj #{size}*16 @ #{addr}").map {|x| "0x%04x" % (x & 0xffff) }; end               # ( word: 16 bits)
  def dwords(addr='$$',size=1); r2("pxwj #{size}*32 @ #{addr}").map {|x| "0x%08x" % (x & 0xffffffff) }; end          # (dword: 32 bits)
  def qwords(addr='$$',size=1); r2("pxqj #{size}*64 @ #{addr}").map {|x| "0x%016x" % (x & 0xffffffffffffffff) }; end # (qword: 64 bits)

  def write_instructions(asm,addr='$$'); r2_eval "\"wa #{asm}\" @ #{addr}"; end # alias `patch`
  def write_bytes(bytes,addr='$$'); r2_eval "wx #{bytes} @ #{addr}"; end # alias `write`
  def write_str(str,addr='$$'); r2_eval "wz #{str} @ #{addr}"; end
  def inverse_jump(addr='$$'); r2_eval "wao swap-cjmp @ #{addr}"; end
  def jz(addr='$$'); r2_eval "wao jz @ #{addr}"; end
  def jnz(addr='$$'); r2_eval "wao jnz @ #{addr}"; end
  def jmp(addr='$$'); r2_eval "wao un-cjmp @ #{addr}"; end
  def int3(addr='$$'); r2_eval "wao trap @ #{addr}"; end
  def ret1(addr='$$'); r2_eval "wao ret1 @ #{addr}"; end
  def ret0(addr='$$'); r2_eval "wao ret0 @ #{addr}"; end
  def nop(addr='$$'); r2_eval "wao nop @ #{addr}"; end

  def esil(str); str.split(',').inject(stack=[]) {|stack,x| if(x[/\W/] && x!='$$'); arg1,arg2=stack.pop(2).reverse; arg2=stack.pop(arg2.to_i) if(x[/\[\*\]/]); stack << {left:arg1, op:x, right:arg2}; else; stack<<x ; end  }; end
  # puts r2('pdfj').ops.map{|op|esil(op['esil'].gsub('$$','0x%08x' % op['offset']))}.to_code
  # TODO: 0x80480,[],eax,=   // mem
  # TODO: 0x80,$             // syscalls
  # TODO: ?{...}             // conditionals
  # TODO: LOOP               // ...and other stuff

  class Object; def references(addr=nil); r2 "axtj #{addr || self}"; end; end
  class Array; def to_code; map(&:to_code).join("\n"); end; end
  class Hash; def to_code; values.map{|x|x.class==Hash ? "(#{x.to_code})" : x.class==Array ? x.join(',') : x}.join(' '); end; end
end

# Other stuff...
begin
  require 'pp'                           # Pretty print (pp) is like p, but with \n in Hash/Arrays...
  require 'awesome_print'                # Colored pretty print, for some special occasions :)
  require 'what_methods'                 # Enable '3.88.what? 4' to show 'ceil' method
  require 'map_by_method'                # Easy usage of map method
rescue LoadError
end

# Extend classes
class Object; def to_struct; self; end; end
class Array; def to_struct; map {|e| e.to_struct }; end; end
class Hash
  def to_struct
    return self if empty?
    struct = Struct.new(*keys.map(&:to_sym))
    struct.new(*map{|k,v| v.is_a?(Hash) ? v.to_struct : v })
  end
end

# Simple prompt (>> ) and auto indent (in for loops, ...)
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
#IRB.conf[:USE_READLINE] = false

# Local history
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "./irb_history.txt"

# Load gems automatically
# if File.exists?('Gemfile') && Object.const_defined?('Bundle')
#   Bundle.require
# end

# Rails 2.x & 3.x
if ENV.include?('RAILS_ENV')
  if !Object.const_defined?('RAILS_DEFAULT_LOGGER')
    require 'logger'
    Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
  end

  def sql(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  if ENV['RAILS_ENV'] == 'test'
    require 'test/test_helper'
  end

elsif defined?(Rails) && !Rails.env.nil? # Rails 3
  if Rails.logger
    Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = Rails.logger
  end
  if Rails.env == 'test'
    require 'test/test_helper'
  end
else
  # nothing to do
end

# Other
def files(dir='.'); Dir["#{dir}/*"]; end

# Intro
intro = "Interactive Ruby Shell :: #{ENV["USER"]} @ Ruby(#{RUBY_VERSION})"
puts intro
intro.size.times { print '~' }
print "\n"

