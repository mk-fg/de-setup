#!/usr/bin/env python3

import itertools as it, operator as op, functools as ft
import os, sys, re, logging, pprint


# 12 colors, repeated 4 times: normal, bright/bold, intense, intense + bright/bold
# "invis" is special #0000 argb, "inverse"/"inverse_bg" set from xterm foreground/background
eet_color_order = [ 'def', 'black', 'red', 'green', 'yellow',
	'blue', 'magenta', 'cyan', 'white', 'invis', 'inverse', 'inverse_bg' ]
eet_color_types = ['normal', 'bold', 'intense', 'intense_bold']
eet_color_special = dict(invis=(0, 0, 0, 0))

# 8 colors, repeated twice: normal, bright/bold; "def" color is "XTerm*foreground"
xterm_color_order = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white']
xterm_color_map = dict(foreground='def', background='inverse')


p = lambda fmt,*a,**k:\
	print(*( [fmt.format(*a,**k)]\
		if isinstance(fmt, str) and (a or k)
		else [[fmt] + list(a), k] ), flush=True)

@ft.total_ordering
class AttrCls:
	def __init__(self, *args, **kws):
		for k,v in it.chain(zip(self.__slots__, args), kws.items()): setattr(self, k, v)
	def _tuple(self): return tuple(getattr(self, k) for k in self.__slots__)
	def __eq__(self, v): return self._tuple() == v._tuple()
	def __lt__(self, v): return self._tuple() < v._tuple()
	def __hash__(self): return hash(self._tuple())
	def __repr__(self):
		return '<{} [{}]>'.format( self.__class__.__name__,
			' '.join(str(getattr(self, k)) for k in self.__slots__) )

class ColorID(AttrCls):
	__slots__ = 'name t'.split()


def main(args=None):
	import argparse
	parser = argparse.ArgumentParser(
		description='Convert xterm colors from'
			' xresources file to eet config sections for terminology.')
	parser.add_argument('xresources', help='Path to xresources file with XTerm* stuff.')

	parser.add_argument('-i', '--indent-base', default=2, type=int, metavar='n',
		help='Base indent level. Default: %(default)s')
	parser.add_argument('-c', '--indent-chars', default='    ', metavar='str',
		help='Indentation level characters, e.g. 4-spaces or tab. Default: %(default)r')

	opts = parser.parse_args(sys.argv[1:] if args is None else args)

	logging.basicConfig(level=logging.INFO)
	log = logging.getLogger('main')

	colors = dict()
	with open(opts.xresources) as src:
		for line in src:
			line = line.strip()
			if not line or line.startswith('#'): continue
			k, v = line.split(':', 1)
			m = re.search(r'^XTerm.*(color\d+|foreground|background)$', k)
			if not m: continue
			k, v = m.group(1), v.lstrip(' #').lower()
			if len(v) == 6: v = tuple(int(c, 16) for c in [v[0:2], v[2:4], v[4:6]])
			elif len(v) == 3: v = tuple(int(c, 16) for c in v)
			else:
				log.warning('Non-hex color value: %r', v)
				continue
			if k.startswith('color'):
				kk = ColorID(int(k[5:]), 'normal')
				if kk.name >= len(xterm_color_order):
					kk.t, kk.name = 'bold', kk.name - len(xterm_color_order)
				kk.name = xterm_color_order[kk.name]
			else: kk = ColorID(xterm_color_map[k], 'normal')
			colors[kk] = v
	assert len(colors) == 18, [len(colors), sorted(colors.keys())]
	# pprint.pprint(colors)

	indent, in_base = opts.indent_chars, opts.indent_base
	for t in eet_color_types:
		for cn_chk in eet_color_order:
			cn = cn_chk
			if cn == 'inverse_bg': cn = 'def'

			t_opts = [t]
			if t == 'intense_bold': t_opts.append('bold')
			t_opts.append('normal') # safest fallback
			for cid_t in t_opts:
				cid = ColorID(cn, cid_t)
				if cid not in colors: continue
				ct = colors[cid]
				break
			else: ct = eet_color_special[cn]
			if len(ct) == 3: ct += (255,) # alpha value

			p('{}group "Config_Color" struct {{', indent * in_base)
			for c, v in zip('rgba', ct):
				p('{}{}value "{}" uchar: {};', indent * in_base, indent, c, v)
			p('{}}}', indent * in_base)

if __name__ == '__main__': sys.exit(main())
