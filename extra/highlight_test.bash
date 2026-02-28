echo "default text" && \
echo '# This is a comment' && \
echo 'single quoted' && \
echo "double quoted" && \
echo `back quoted` && \
echo $HOME && \
echo ${VAR} && \
ls -la --help && \
cp file*.txt ~/documents/ && \
( echo "nested"; { echo "braces"; [[ test ]] } ) && \
alias myalias='ls' && \
myalias && \
command /bin/ls && \
builtin cd && \
function myfunc() { echo "test"; } && \
myfunc && \
echo $VARIABLE=value && \
! history-search-backward && \
if [[ true ]]; then echo "reserved words"; fi && \
echo $SOME_VAR && \
echo --long-option && \
echo -short
