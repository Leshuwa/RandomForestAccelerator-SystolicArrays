import numpy as np
from matplotlib import pyplot as plt
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn import tree
import graphviz

#The quantization mapping of a floating point value x (value between 0.1 and 7.9) to  
#a 4 bit integer (value between 0 and 15).
#More details about the quantization formula in the documentation (page: ).
def quantize(x):
    return clip(int((round((1 / (7.8 / 15)) * x) + round(((7.9 * 0) - (0.1 * 15)) / 7.8))), 0, 15)
def clip(rounded, minimum, maximum):
    if(rounded < minimum): return minimum
    elif(minimum <= rounded and rounded <= maximum): return rounded
    else: return maximum
    
#toBinary function gets an integer(x) as input and returns a 4 bit representation of the integer.
def toBinary(x):
    # when x is equal to -2, this means there is no feature to be compared with the input,
    # and thus we are at the end of the decision and can get the corresponding class.
    # so we set the feature to 1111.
    if (x == -2): 
        x = 15
    # when x is -1, this means the current node has no left or right children,
    # and so we chose x = 0 to represent it in binary,
    #since it's not possible for any node to have the root node as its child.
    if (x == -1):
        x = 0
    bnr = bin(x).replace('0b','')
    y = bnr[::-1]
    while len(y)<4:
        y+='0'
    bnr = y[::-1]
    return(bnr)

#value : array of double, shape [node_count, n_outputs, max_n_classes]
#Contains the constant prediction value of each node.    
#getClass takes the values Array as input, and the returns the class with the maximum number of predictions. Basically
# it returns the class of the node in question.
def getClass(valuesArray):
    for x in valuesArray:
        max_value = max(x)
        classes = np.where(x == max_value)
    return classes 
#defines and initilizes an array (classesArray) containing the class of each node in the decision tree in Preorder.
def makeClassArray(valueNumpy, nodeCount):
    i = 0
    classesArray = [None] * nodeCount
    for x in valueNumpy:
        classesArray[i] = getClass(x)[0][0]
        i = i + 1
    return classesArray
    
###############################################################################################################   

#Line 66 - 71: loads the iris data set, splits the data into test and trainig data, builds the random forest
#classifier containing 10 different decision trees with max depth of 3. It then fits the data to the model.
#after research and trial and error, we found out that in our case (iris data set), 10 decision trees and 
#a max depth of 3 are suitable to get the highest possible accuracy.
iris = load_iris()
x = iris.data
y = iris.target
X_train, X_test, y_train, y_test = train_test_split(x,y,test_size = 0.3, random_state = 0)
forest = RandomForestClassifier(n_estimators = 10, max_depth= 3, random_state = 1, n_jobs = 1)
forest.fit(X_train, y_train)

#calls the quantize function for each tree in the random forest. Used to replace current threshold and test values
#with their corresponding quantized values.
def quantizeTrees():
    for i in range(0,10):
        for x in range(0,len(forest.estimators_[i].tree_.threshold)):
            forest.estimators_[i].tree_.threshold[x] = quantize(forest.estimators_[i].tree_.threshold[x])  
    for x in X_test:
        for i in range(0,len(x)):
            x[i] = quantize(x[i]) 

quantizeTrees()

#Arrays defined to hold the data of random forest.
estimatorArray = [None] * 10
thresholdArray = [None] * 10
lcArray = [None] * 10
rcArray = [None] * 10
featuresArray = [None] * 10
valuesArray = [None] * 10
classArray = [None] * 10

#fills the estimatorArray with the estimators of the random forest.
def estimatorArray():
    test = [None] * 10
    for i in range (10):
        test[i] = forest.estimators_[i]
    return test
estimatorArray = estimatorArray()

#fills the thresholdArray with the thresholds of each estimator.
def thresholdArray():
    test = [None] * 10
    for i in range (10):
        test[i] = estimatorArray[i].tree_.threshold
    return test
thresholdArray = thresholdArray()

#fills the leftChildArray with the left children of each estimator. 
def lcArray():
    test = [None] * 10
    for i in range (10):
        test[i] = estimatorArray[i].tree_.children_left
    return test
lcArray = lcArray()

#fills the rightChildArray with the right children of each estimator. 
def rcArray():
    test = [None] * 10
    for i in range (10):
        test[i] = estimatorArray[i].tree_.children_right
    return test
rcArray = rcArray()

#fills the featuresArray with the features of each estimator.
def featuresArray():
    test = [None] * 10
    for i in range (10):
        test[i] = estimatorArray[i].tree_.feature
    return test
featuresArray = featuresArray()

#the values in this array are used in the makeClassArray function, in order to determine the class of each node.
def valuesArray():
    test = [None] * 10
    for i in range (10):
        test[i] = estimatorArray[i].tree_.value
    return test
valuesArray = valuesArray()

#fills the classArray with the classes of all nodes for each estimator.
def classArray():
    test = [None] * 10
    for i in range (10):
        test[i] = makeClassArray(valuesArray[i],estimatorArray[i].tree_.node_count)
    return test
classArray = classArray()
 
#defines an array for every node of each estimator of the decision tree. Each element in the array contains information
#corresponding to the node ( threshold, feature, leftchild, rightchild, class).
def nodeMaker(threshold, feature, leftchild, rightchild, Class, nodeId):
    node = [None] * 5
    node[0] = toBinary(int(threshold[nodeId]))
    node[1] = toBinary(feature[nodeId])
    node[2] = toBinary(leftchild[nodeId])
    node[3] = toBinary(rightchild[nodeId])
    node[4] = toBinary(Class[nodeId])
    return node
    

#writes the node information of each decision tree in the random forest in a txt files, which will be used in the vivado
#project as input for the memory of the the hardware design. This function calls the function nodeMaker to create
#the node Arrays of each tree and writes them to the txt file as a 20 bit data stream.
def printNodes(nodeCount, thresholds, features, nodesLeftChildren, nodesRightChildren,classArray, text):
    for x in range(nodeCount):
        node = nodeMaker(thresholds, features, nodesLeftChildren, nodesRightChildren, classArray, x)
        for x in node:
            print(x, file = open(text,"a"), end = "")
        print("", file = open(text,"a"))
    print("", file = open(text,"a"))

#truncates the txt data in which the information are written.
file = open("random-forest.txt","r+")
file.truncate(0)
file.close()

#calls on the function printNodes for all the trees in the random forest.
def writeNodeData():
    for i in range (10):
        printNodes(estimatorArray[i].tree_.node_count, thresholdArray[i], featuresArray[i], lcArray[i], rcArray[i], classArray[i], "random-forest.txt")

writeNodeData()

#exports a graph representation of each tree.
def printTrees():
    dot_data0 = tree.export_graphviz(estimatorArray[0], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data1 = tree.export_graphviz(estimatorArray[1], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data2 = tree.export_graphviz(estimatorArray[2], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data3 = tree.export_graphviz(estimatorArray[3], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data4 = tree.export_graphviz(estimatorArray[4], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data5 = tree.export_graphviz(estimatorArray[5], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data6 = tree.export_graphviz(estimatorArray[6], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data7 = tree.export_graphviz(estimatorArray[7], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data8 = tree.export_graphviz(estimatorArray[8], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    dot_data9 = tree.export_graphviz(estimatorArray[9], out_file=None, feature_names=iris.feature_names, class_names=iris.target_names, filled=True, rounded=True, special_characters=True)
    graph0 = graphviz.Source(dot_data0)
    graph1 = graphviz.Source(dot_data1)
    graph2 = graphviz.Source(dot_data2)
    graph3 = graphviz.Source(dot_data3)
    graph4 = graphviz.Source(dot_data4)
    graph5 = graphviz.Source(dot_data5)
    graph6 = graphviz.Source(dot_data6)
    graph7 = graphviz.Source(dot_data7)
    graph8 = graphviz.Source(dot_data8)
    graph9 = graphviz.Source(dot_data9)
    graph0.render("tree0")
    graph1.render("tree1")
    graph2.render("tree2")
    graph3.render("tree3")
    graph4.render("tree4")
    graph5.render("tree5")
    graph6.render("tree6")
    graph7.render("tree7")
    graph8.render("tree8")
    graph9.render("tree9")
 
printTrees()

