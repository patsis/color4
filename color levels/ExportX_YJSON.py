
#!/usr/bin/env python
#
# curve xy co-ordinate export
# Authors:
# Jean Moreno <jean.moreno.fr@gmail.com>
# John Cliff <john.cliff@gmail.com>
# Neon22 <https://github.com/Neon22?tab=repositories>
# Jens N. Lallensack <jens.lallensack@gmail.com>
#
# Copyright (C) 2011 Jean Moreno
# Copyright (C) 2011 John Cliff 
# Copyright (C) 2011 Neon22
# Copyright (C) 2019 Jens N. Lallensack
#
# Released under GNU GPL v3, see https://www.gnu.org/licenses/gpl-3.0.en.html for details.

import inkex
import sys
import simpletransform
import cubicsuperpath

def warn(*args, **kwargs):
    pass
import warnings
warnings.warn = warn

class TemplateEffect(inkex.Effect):
    def __init__(self):
        inkex.Effect.__init__(self)
    def effect(self):
        # for node in self.selected.items():
        output_nodes = ""
        shapeid = 1
        for id, node in self.selected.items():
            output_nodes += "{\n"
            output_nodes += "\t\"id\":"
            output_nodes += str(shapeid)
            output_nodes += ",\n"
            output_nodes += "\t\"points\":[\n"
            output_nodes += "\t\t"
            if node.tag == inkex.addNS('path','svg'):
                simpletransform.fuseTransform(node)
                d = node.get('d')
                p = cubicsuperpath.parsePath(d)
                first = 1
                # whe need the coordinates in the form MOVE XY, ..."CP1 XY, CP2 XY, PT XY,"...
                for subpath in p:
                    # for csp in subpath:
                    cnt = len(subpath) - 1
                    i = 1

                    fsp = subpath[0]                        
                    output_nodes += str(round(fsp[1][0])) # MOVE x
                    output_nodes += ","                            
                    output_nodes += str(round(fsp[1][1])) # MOVE y
                    output_nodes += ","                        
                    
                    while i < cnt:
                        psp = subpath[i - 1]
                        output_nodes += str(round(psp[2][0])) # CP1 x
                        output_nodes += ","                            
                        output_nodes += str(round(psp[2][1])) # CP1 y
                        output_nodes += ","                                            
                                                
                        csp = subpath[i]
                        output_nodes += str(round(csp[0][0])) # CP2 x
                        output_nodes += ","                            
                        output_nodes += str(round(csp[0][1])) # CP2 y
                        output_nodes += ","                            
                        
                        
                        output_nodes += str(round(csp[1][0])) # PT x
                        output_nodes += ","                            
                        output_nodes += str(round(csp[1][1])) # PR y
                        i = i + 1
                        if i < cnt: # omit last 
                            output_nodes += ","
                    
                    lsp = subpath[cnt - 1]
                    if round(fsp[1][0]) != round(lsp[1][0]) or round(fsp[1][1]) != round(lsp[1][1]):
                        output_nodes += "\n* OPEN *"
                    # while
                # for subpath
            # if
            output_nodes += "\n"
            output_nodes += "\t]\n"
            output_nodes += "},\n"
            shapeid += 1
        sys.stderr.write(output_nodes)
effect = TemplateEffect()
effect.affect()
