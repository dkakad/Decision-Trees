classdef DecisionTreeNode < handle
    %DecisionTreeNode class: Nodes of entropy-based binary decision tree.
    % For 24787, you will need to fill in the missing pieces in this file.
    
    properties
        decision_attrib;        % the index of the attrib where split occurs
        available_attribs;      % the indices of available attributes
        decision;               % the class for all input data, if no split occurs
        left_node;              % handle to the left leaf
        right_node;             % handle to the right leaf
        parent_node;            % handle to the parent leaf
    end
    
    methods
        function this = DecisionTreeNode()
            this.decision_attrib = -1;
            this.decision = -1;
            this.parent_node = [];
            this.available_attribs = [];
        end
        
        %% 24787 students: fill in the missing parts of this function
        function find_decision_attrib(this, attrib, class)

            h = DecisionTreeNode.entropy_of_class(class);
            info_gain = zeros(size(this.available_attribs));
            for i = 1 : size(this.available_attribs, 2)
                M_1_1 = 0;
                M_1_0 = 0;
                M_0_1 = 0;
                M_0_0 = 0;
                for j = 1 : size(attrib, 1)
                    M_1_1 = M_1_1 + ((attrib(j,i) == 1) && (class(j,1) == 1));
                    M_1_0 = M_1_0 + ((attrib(j,i) == 1) && (class(j,1) == 0));
                    M_0_1 = M_0_1 + ((attrib(j,i) == 0) && (class(j,1) == 1));
                    M_0_0 = M_0_0 + ((attrib(j,i) == 0) && (class(j,1) == 0));
                end
                               
                M = M_1_1 + M_1_0 + M_0_1 + M_0_0;
                
                if(M_1_1 == 0)
                    p_left_pos = 0;
                else
                    p_left_pos = M_1_1 / (M_1_1 + M_1_0);
                end
                p_left_neg = 1 - p_left_pos;
                p_left = [p_left_pos, p_left_neg];
                h_left = this.entropy(p_left);
                
                if (M_0_1 == 0)
                    p_right_pos = 0;
                else
                    p_right_pos = M_0_1 / (M_0_1 + M_0_0);
                end
                p_right_neg = 1 - p_right_pos;
                p_right = [p_right_pos, p_right_neg];
                
                h_right = this.entropy(p_right);
                
                W_left = (M_1_1 + M_1_0) / M;
                W_right = (M_0_1 + M_0_0) / M;

                
                H = W_left * h_left + W_right * h_right;
                info_gain(i) = h - H;         
            end
            
            if(all(info_gain == info_gain(1)))
                idx = this.available_attribs(randi(length(this.available_attribs)));
            else
                [val, idx] = max(info_gain);
            end
            this.decision_attrib = idx;
            best_index = find(this.available_attribs == idx);
            this.available_attribs(best_index) = [];
            
                
            
%            From available_attribs, you want to find the attribute that 
%            best splits the data with maximum info gain. 
%            You will need to split the data per each available attribute.
%            You may use the following functions:
%                   DecisionTreeNode.entropy_of_class()
%                   DecisionTreeNode.entropy()
%                      
            % Write your code below


        end
        
        %% 24787 students: fill in the missing parts of this function
        function train(this, attrib, class)
            % hint: this will be a recursive function
            
            %if examples are all positive or all negative then the data is
            %perfectly split. Hence assign the 'classification' and return
            %from this node.
            % Write your code below
            if(size(find(class), 1) == size(class, 1))
                this.decision = 1;
                return;
            elseif (size(find(~class), 1) == size(class, 1))
                this.decision = 0;
                return;
            elseif (length(this.available_attribs) == 0 || size(class ,1 ) < 5)
                if(size(find(~class), 1) >= size(find(class), 1))
                    this.decision = 0;
                else
                    this.decision = 1;
                end
                return;
            else
                this.find_decision_attrib(attrib, class);
                attrib_1_samples_idx = attrib(:, this.decision_attrib) == 1;
                attrib_0_samples_idx = attrib(:, this.decision_attrib) == 0;
                this.left_node = DecisionTreeNode();
                this.left_node.available_attribs = this.available_attribs;
                this.left_node.parent_node = this;
                this.right_node = DecisionTreeNode();
                this.right_node.available_attribs = this.available_attribs;
                this.right_node.parent_node = this;
                this.left_node.train(attrib(attrib_1_samples_idx,:), class(attrib_1_samples_idx,:));
                this.right_node.train(attrib(attrib_0_samples_idx,:), class(attrib_0_samples_idx,:));
            end
                
            
            
            
            
            %check if there is any available (i.e. unused) attribute
            %if no available attribs remain, but still some + and - examples
            %use the MAJORITY VOTE
            %that is, if #of +'ve examples > #of -'ve examples
            %then set this node's classification to be 1 else 0.
            % Write your code below        
                       
            %if the program runs here,then there are still some available attribs
            %and some positive and negative examples.
            %Hence choose the attribute that splits the data the best,
            %split the dataset and initiate the recursion.
            % Write your code below        
            
            
            
            
            
            
        end
        
        %% 24787 students: study the recursive structure of this function
        % and use it elsewhere in this file
        function class = classify(this, attrib)
            % initialize class labels to -1
            class = -1 * ones(size(attrib, 1), 1);
            
            if this.decision_attrib == -1
                % we are at a leaf node.
                % no split needed. then assign node's decision to all data
                class = this.decision * ones(size(attrib, 1), 1);
            else % recursively classify all data
                % split samples into two sets
                attrib_1_samples_idx = attrib(:, this.decision_attrib) == 1;
                attrib_0_samples_idx = attrib(:, this.decision_attrib) == 0;
                
                class(attrib_1_samples_idx, :) = this.left_node.classify(attrib(attrib_1_samples_idx,:));
                class(attrib_0_samples_idx, :) = this.right_node.classify(attrib(attrib_0_samples_idx,:));
            end  
        end
    end
    
    % Static member functions can be called without object instantiation.
    % Namely, you should call DecisionTreeNode.entropy(), rather than
    % my_dt.entropy()    
    methods (Static)
        %% 24787 students: fill in the missing parts of this function
		% p is a vector of two elements, each being the probability of class = 1 and class = 0
        function h = entropy(p)
		    p_pos = p(1);
            p_neg = p(2);
            if(p_pos == 0)
                h1 = 0;
            else
                h1 = -p_pos * (log2(p_pos));
            end
            
            if(p_neg == 0)
                h2 = 0;
            else
                h2 = - p_neg * (log2(p_neg));
            end
            h = h1 + h2;
        end
        
        %% 24787 students: fill in the missing parts of this function
		% class is a binary vector, in which Joy = 1 and Despair = 0
        function h = entropy_of_class(class)
            p_pos = size(find(class),1) / size(class,1);
            p_neg = size(find(~class),1) / size(class,1);
            p = [p_pos , p_neg];
            h = DecisionTreeNode.entropy(p);
        end
    end
end