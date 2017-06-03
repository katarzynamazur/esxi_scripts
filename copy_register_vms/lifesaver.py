#!/usr/bin/env python3
import sys

def help():
    print("\nUsage:\n\t./{0} {1} {2}\n\n".format(sys.argv[0], "change_from", "change_to"))

if __name__ == "__main__":

    if len(sys.argv) != 4 :

        help()

    else:

        chgfrom = str(sys.argv[1])
        chgto = str(sys.argv[2])
        snapnum = str(sys.argv[3])

        infile = "%s_0.vmdk" % (chgfrom)
        outfile = "%s_0.vmdk" % (chgto)

        with open(infile, 'r',encoding='utf-8', errors='ignore') as inf, open(outfile, 'w') as outf :
            try:
                for line in inf :
                    line = line.replace('%s_0-flat.vmdk', "%s_0-flat.vmdk" % (chgfrom, chgto))
                    outf.write(line)
            except Exception:
                pass

        infiles = ['%s-Snapshot%s.vmsn' % (chgfrom, snapnum), '%s.vmx' % (chgfrom), '%s_0-000001.vmdk' % (chgfrom), '%s_0.vmdk' % (chgfrom), '%s.vmsd' % (chgfrom)]
        outfiles = ['%s-Snapshot%s.vmsn'% (chgto, snapnum), '%s.vmx'% (chgto), '%s_0-000001.vmdk'% (chgto), '%s_0.vmdk'% (chgto), '%s.vmsd'% (chgto)]

        for infile, outfile in zip(infiles, outfiles) :
            with open(infile, 'r',encoding='utf-8', errors='ignore') as inf, open(outfile, 'w') as outf :
                try:
                    for line in inf :
                        line = line.replace('%s' % chgfrom, '%s' % chgto)
                        outf.write(line)
                except Exception:
                    pass

