function [ tf ] = isAbstract( iClassName )
    m = meta.class.fromName(iClassName);
    tf = m.Abstract;
end

