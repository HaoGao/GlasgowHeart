SXSliceSortedTemp = SXSliceSorted([1 2, 4,5,6]);
SXSliceSorted = SXSliceSortedTemp;

SXSliceAll = imDesired.SXSlice;
SXSliceAllT = SXSliceAll([1,2,4,5,6]);
SXSliceAll = SXSliceAllT;
imDesired.SXSlice = SXSliceAll;

save imDesired imDesired SXSliceSorted LVOTSliceSorted;
