original_list_size = CodeGen::List.size

class Perl6 < CodeGen
  After = Perl
  Name = "Perl 6"
  File = "QR.pl6"
  Cmd = "perl6 QR.pl6 > OUTFILE"
  Apt = "rakudo"
  Code = %q("print('#{Q[Q[PREV,B],?']}')")
end

class Perl
  Name = "Perl 5"
end

class Parser3 < CodeGen
  After = PARIGP
  Name = "Parser 3"
  File = "QR.p"
  Cmd = "parser3 QR.p > OUTFILE"
  Apt = "parser3-cgi"
  Code = %q("$console:line[#{PREV.gsub(/[:;()]/){?^+$&}}]")
end

class NesC < CodeGen
  After = Neko
  Name = "nesC"
  File = "QR.nc"
  Cmd = "nescc -o QR QR.nc && ./QR > OUTFILE"
  Apt = "nescc"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        #include<stdio.h>\n
        module QR{}implementation{
          int main()__attribute__((C,spontaneous)){
            puts#{E[PREV]};
            return 0;
          }
        }
      )
    END
  end
end

class M4 < CodeGen
  After = Lua
  File = "QR.m4"
  Cmd = "m4 QR.m4 > OUTFILE"
  Apt = "m4"
  Code = %q("changequote(<@,@>)\ndefine(p,<@#{PREV}@>)\np")
end

class Julia_Ksh_LazyK_Lisaac < CodeGen
  After = Jq
  Obsoletes = Julia_LazyK_Lisaac
  Name = ["Julia", "ksh", "Lazy K", "Lisaac"]
  File = ["QR.jl", "QR.ksh", "QR.lazy", "qr.li"]
  Cmd = [
    "julia QR.jl > OUTFILE",
    "ksh QR.ksh > OUTFILE",
    "lazyk QR.lazy > OUTFILE",
    "lisaac qr.li && ./qr > OUTFILE",
  ]
  Apt = ["julia", "ksh", nil, "lisaac"]
  def code
    lazyk = ::File.read(::File.join(__dir__, "lazyk-boot.dat"))
    lazyk = lazyk.tr("ski`","0123").scan(/.{1,3}/).map do |n|
      n = n.reverse.to_i(4)
      [*93..124,*42..73][n]
    end.pack("C*")
    lazyk = lazyk.gsub(/[ZHJK\^`~X]/) {|c| "\\x%02x" % c.ord }
    <<-'END'.lines.map {|l| l.strip }.join.sub("LAZYK"){lazyk}
      %(
        A=print;
        A("echo 'k`");
        [
          (
            A("``s"^8*"i");
            for j=6:-1:0;
              x=(Int(c)>>j)%2+1;
              A("`"*"kki"[x:x+1])
            end
          )for c in join([
            "SectionHeader+name:=QR;SectionPublic-main<-(";
            ["\\"$(replace(replace(s,"\\\\","\\\\\\\\"),"\\"","\\\\\\""))\\".print;"for s=matchall(r".{1,99}",#{Q[E[PREV]]})];
            ");"
          ],"\\n")
        ];
        [
          for i=0:2:4;
            x=((Int(c)%83-10)>>i)%4+1;
            A("ski`"[x:x])
          end for c in"LAZYK"
        ];
        A("'")
      )
    END
  end
end

class LLVMAsm
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        @s=global[#{i=(s=PREV).size+1}x i8]
          c"#{s.gsub(/[\\"\n\t]/){"\\%02X"%$&.ord}}\\00"
        declare i32@puts(i8*)
        define i32@main(){
          %1=call i32@puts(i8*getelementptr([#{i}x i8],[#{i}x i8]*@s,i32 0,i32 0))
          ret i32 0
        }
      )
    END
  end
end

class LiveScript < CodeGen
  After = Julia_Ksh_LazyK_Lisaac
  Name = "LiveScript"
  File = "QR.ls"
  Cmd = "lsc QR.ls > OUTFILE"
  Apt = "livescript"
  Code = %q("console.log"+Q[E[PREV],?#])
end

class JavaScript_Jq_JSFuck < CodeGen
  After = Java_
  Obsoletes = [JavaScript, Jq]
  File = ["QR.js", "QR.jq", "QR.jsfuck"]
  Cmd = [
    "$(JAVASCRIPT) QR.js > OUTFILE",
    "jq -r -n -f QR.jq > OUTFILE",
    "!$(JAVASCRIPT) --stack_size=100000 QR.jsfuck > OUTFILE",
  ]
  Apt = ["nodejs", "jq", "nodejs"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        m={0:"[+[]]",m:"((+[])"+(C="['constructor']")+"+[])['11']"};
        for(j in a=("![]/!![]/[][[]]/"+(F="[]['fill']")+"/([]+[])['fontcolor']([])/(+('11e20')+[])['split']([])/"+F+C+"('return escape')()("+F+")").split("/"))
          for(i in k=eval(s="("+a[j]+"+[])"))
            m[t=k[i]]=m[t]||s+"['"+i+"']";
        s="[";
        for(c=1;c<36;c++)
          m[k=c.toString(36)]=c<10?(s+="+!+[]")+"]":m[k]||"(+('"+c+"'))['to'+([]+[])"+C+"['name']]('36')";
        s=#{E[PREV]};
        o=F+C+"('console.log(unescape(\\"";
        for(i in s)o+="'+![]+'"+s.charCodeAt(i).toString(16);
        o+="\\".replace(/'+![]+'/g,\\"%\\")))')()";
        for(j=0;j<99;j++)o=o.replace(/'.*?'/g,function(c){
          t=[];
          for(i=1;c[i+1];)t.push(m[c[i++]]);
          return t.join("+")
        });
        console.log('"'+o+'"')
      )
    END
  end
end

class Gri_Groovy_Gzip < CodeGen
  After = Go_GPortugol_Grass
  Obsoletes = Groovy
  File = ["QR.gri", "QR.groovy", "QR.gz"]
  Cmd = ["gri QR.gri > OUTFILE", "groovy QR.groovy > OUTFILE", "gzip -cd QR.gz > OUTFILE"]
  Apt = ["gri", "groovy", "gzip"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        \\q="\\""\n
        show "
          def z=new java.util.zip.GZIPOutputStream(System.out);
          z.write('#{PREV.tr(B,?!).gsub(?",%(" "\\q" "))}'.tr('!','\\\\\\\\').getBytes());
          z.close()
        "
      )+N
    END
  end
end

class GolfScript_GPortugol_Grass < CodeGen
  After = Go_GPortugol_Grass
  Obsoletes = Go_GPortugol_Grass
  Name = ["GolfScript", "G-Portugol", "Grass"]
  File = ["QR.gs", "QR.gpt", "QR.grass"]
  Cmd = ["ruby vendor/golfscript.rb QR.gs > OUTFILE", "gpt -o QR QR.gpt && ./QR > OUTFILE", "ruby vendor/grass.rb QR.grass > OUTFILE"]
  Apt = [nil, "gpt", nil]
  def code
    r = <<-'END'.lines.map {|l| l.strip }.join
      %(
        @@BASE@@:j;
        {
          119:i;
          {
            206i-:i;
            .48<{71+}{[i]\\48-*}if
          }%
        }:t;
        "algoritmo QR;in"[195][173]++'cio imprima("'
        @@PROLOGUE@@
        "#{e[PREV]}"
        {
          "W""w"@j 1+:j\\- @@MOD@@%1+*
        }%
        @@EPILOGUE@@
        '");fim'
      )
    END
    mod, prologue, epilogue = ::File.read(::File.join(__dir__, "grass-boot.dat")).lines
    prologue += "t"
    epilogue += "t"
    prologue = prologue.gsub(/(\/12131)+/) { "\"t\"/12131\"t #{ $&.size / 6 }*\"" }
    mod = mod.to_i
    r.gsub(/@@\w+@@/, {
      "@@PROLOGUE@@" => prologue.chomp,
      "@@EPILOGUE@@" => epilogue.chomp,
      "@@BASE@@" => 119 + mod - 1,
      "@@MOD@@" => mod,
    })
  end
end

class Go < CodeGen
  After = Gnuplot
  File = "QR.go"
  Cmd = "go run QR.go > OUTFILE"
  Apt = "golang"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        package main;
        import"fmt";
        func main(){
          fmt.Print#{E[PREV]};
        }
      )
    END
  end
end

class Curry < CodeGen
  After = CommonLisp
  File = "QR.curry"
  Cmd = "touch ~/.pakcsrc && runcurry QR.curry > OUTFILE"
  Apt = "pakcs"
  Code = %q("main=putStr"+E[PREV])
end

class CoffeeScript < CodeGen
  Cmd.replace "coffee --nodejs --stack_size=100000 QR.coffee > OUTFILE"
end

class C < CodeGen
  c = C.new.code.gsub("99999", "999999")
  define_method(:code) { c }
end

class Bash_Bc_Befunge_BLC8_Brainfuck < CodeGen
  After = Awk_Bc_Befunge_BLC8_Brainfuck
  Obsoletes = Awk_Bc_Befunge_BLC8_Brainfuck
  Name = ["bash", "bc", "Befunge", "BLC8", "Brainfuck"]
  File = ["QR.bash", "QR.bc", "QR.bef", "QR.Blc", "QR.bf"]
  Cmd = [
    "bash QR.bash > OUTFILE",
    "BC_LINE_LENGTH=4000000 bc -q QR.bc > OUTFILE",
    "cfunge QR.bef > OUTFILE",
    "ruby vendor/blc.rb < QR.Blc > OUTFILE",
    "$(BF) QR.bf > OUTFILE",
  ]
  Apt = ["bash", "bc", nil, nil, "bf"]
  def code
    blc = ::File.read(::File.join(__dir__, "blc-boot.dat"))
    <<-'END'.lines.map {|l| l.strip }.join.sub("BLC", [blc].pack("m0"))
      %(
        echo "
          define void f(n){
            \\"00g,\\";
            for(m=1;m<256;m*=2){
              \\"00g,4,:\\";
              if(n/m%2)\\"4+\\";
              \\",\\";
            };
            \\"4,:,\\"
          }
          \\"389**6+44*6+00p45*,\\";
        ";
        for n in \x60echo '#{d[PREV,B].gsub(?',%('"'"'))}'|od -An -tuC\x60;do echo "f($n);";done;
        s="\\"4,:,";
        for n in \x60echo BLC|base64 -d|od -An -tuC\x60;do s=$s"0";
          for ((k=0;k<n;k++));do s=$s"1+";done;
          s=$s",";
        done;
        echo $s"@\\"";
        echo quit
      )
    END
  end
end

class Awk < CodeGen
  After = ATS
  Name = "Awk"
  File = "QR.awk"
  Cmd = "awk -f QR.awk > OUTFILE"
  Apt = "gawk"
  Code = %q("BEGIN{print#{E[PREV]}}")
end

class AFNIX_Aheui < CodeGen
  After = AFNIX
  Obsoletes = AFNIX
  File = ["QR.als", "QR.aheui"]
  Cmd = ["axi QR.als > OUTFILE", "go run vendor/goaheui/main.go QR.aheui > OUTFILE"]
  Apt = ["afnix", nil]
  def code
    <<-'END'.lines.map {|l| l.strip }.join.gsub("$$$", " ")
      %(
        interp:library"afnix-sio"\n
        trans o(afnix:sio:OutputTerm)\n
        trans O(n){o:write(Byte(+ 128 n))}\n
        trans f(n){\n
        trans t(/ n 64)\n
        O(+(/ n 4096)96)\n
        O(t:mod 64)\n
        O(n:mod 64)}\n
        trans D(n){if(< n 4){f(+(* 6 n)48137)}{if(n:odd-p){D(- n 3)\n
        f 48155\n
        f 45796}{D(/ n 2)\n
        f 48149\n
        f 46384}}}\n
        trans S"#{e[PREV]}"\n
        trans c 0\n
        do{D(Integer(S:get c))\n
        f 47587}(<(c:++)(S:length))\n
        f 54616
      )
    END
  end
end

class Ada < CodeGen
  def code
    <<-'END'.lines.map {|l| l.strip }.join.gsub("$$$", " ")
      %(
        with Ada.Text_Io;
        procedure qr is$$$
        begin$$$
          #{PREV.gsub(/(.{1,25000})(\n)?/){%(Ada.Text_Io.Put#{$2?:_Line:""}("#{d[$1]}");\n)}}
        end;
      )
    END
  end
end

class Zsh < CodeGen
  After = Zoem
  Name = "zsh"
  File = "QR.zsh"
  Cmd = "zsh QR.zsh > OUTFILE"
  Apt = "zsh"
  Code = %q("echo -E $'#{Q[Q[PREV,B],?']}'")
end

class Yorick
  Code.replace %q(%(write,format="#{y="";f(PREV,30){y<<",\\n"+$S;"%s"}}")+y)
end

class Yabasic < CodeGen
  After = XSLT
  File = "QR.yab"
  Cmd = "yabasic QR.yab > OUTFILE"
  Apt = "yabasic"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        sub f(s$,n)
          print(s$);:
          for i=1to n print("\\\\");:
          next:
        end sub:
        f("#{V[e[PREV],'",','):f("']}",0)
      )
    END
  end
end

class VimScript < CodeGen
  After = Verilog
  Name = ["Vimscript"]
  Apt = "vim"
  File = "QR.vim"
  Cmd = "vim -EsS QR.vim > OUTFILE"
  Code = %q("let s=#{E[PREV]}\nput=s\nprint\nqa!")
end

class TypeScript_Unlambda < CodeGen
  After = Tcl_Thue_Unlambda
  File = ["QR.ts", "QR.unl"]
  Cmd = ["tsc --outFile QR.ts.js QR.ts && $(JAVASCRIPT) QR.ts.js > OUTFILE", "ruby vendor/unlambda.rb QR.unl > OUTFILE"]
  Apt = ["node-typescript", nil]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      "let s=#{E[PREV]},i=s.length,t='';while(i--){t+='\\x60.'+s[i]};console.log(t+'k')"
    END
  end
end

class Tcsh_Thue < CodeGen
  After = Tcl_Thue_Unlambda
  Name = ["tcsh", "Thue"]
  File = ["QR.tcsh", "QR.t"]
  Cmd = ["tcsh QR.tcsh > OUTFILE", "ruby vendor/thue.rb QR.t > OUTFILE"]
  Apt = ["tcsh", nil]
  Code = %q("echo 'a::=~#{Q[Q[PREV,B],?!].gsub(?',%('"'"'))}';echo ::=;echo a")
end

class Tcl < CodeGen
  After = Tcl_Thue_Unlambda
  Obsoletes = Tcl_Thue_Unlambda
  File = "QR.tcl"
  Cmd = "tclsh QR.tcl > OUTFILE"
  Apt = "tcl"
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        proc f {n} {string repeat "\\\\" $n};
        puts "#{V[Q[e[PREV],/[\[\]$]/],"[f ",?]]}"
      )
    END
  end
end

class Scilab_SLang < CodeGen
  After = Scilab
  Obsoletes = [Scilab, Shell_SLang]
  Name = ["Scilab", "S-Lang"]
  File = ["QR.sci", "QR.sl"]
  Cmd = ["scilab -nwni -nb -f QR.sci > OUTFILE", "slsh QR.sl > OUTFILE"]
  Apt = ["scilab", "slsh"]
  def code
    <<-'END'.lines.map {|l| l.strip }.join
      %(
        function []=f(s);printf("()=printf(""%%s"",""%s"");\\n",s)endfunction\n
        #{PREV.gsub(/.{1,120}/m){%(f("#{d[d[e[$&]],?']}")\n)}}\n
        quit
      )
    END
  end
end

class Rust < CodeGen
  After = Ruby
  File = "QR.rs"
  Cmd = "rustc QR.rs && ./QR > OUTFILE"
  Apt = "rustc"
  Code = %q(%(fn main(){print!("{}",#{E[PREV]});}))
end

CodeGen::List.slice!(original_list_size..-1).each do |s|
  i = CodeGen::List.find_index(s::After)
  CodeGen::List.insert(i, s)
  [*s::Obsoletes].each {|s_| CodeGen::List.delete(s_) } if defined?(s::Obsoletes)
end
